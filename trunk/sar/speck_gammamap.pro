;------------------------------------------------------------------------
; RAT - Radar Tools
;------------------------------------------------------------------------
; RAT Module: speck_gammamap
; last revision : 28.May 2003
; written by    : Andre Lehmann
; Gamma MAP speckle filter
;------------------------------------------------------------------------
; The contents of this file are subject to the Mozilla Public License
; Version 1.1 (the "License"); you may not use this file except in
; compliance with the License. You may obtain a copy of the License at
; http://www.mozilla.org/MPL/
;
; Software distributed under the License is distributed on an "AS IS"
; basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
; License for the specific language governing rights and limitations
; under the License.
;
; The Initial Developer of the Original Code is the RAT development team.
; All Rights Reserved.
;------------------------------------------------------------------------

function gammamap, amp, smm, LOOKS = looks
	if not keyword_set(looks) then looks=1

	siz     = size(amp)
	block_x = siz[1]
	block_y = siz[2]
	rand    = (smm-1)/2
	sig_v2  = 1.0 / looks
	looks2  = looks + 1
	sfak    = 1.0 + sig_v2
	smm2    = smm^2
	fbox    = mbox(smm,block_x)

	m2arr  = smooth(amp^2,smm)
	marr   = smooth(amp,smm)
	var_z  = m2arr - marr^2 
	
	out = marr
	index  = where(var_z / marr^2 gt sig_v2,nr)
	if nr gt 0 then begin
		n = (marr^2 * sfak) / (var_z - marr^2 * sig_v2)
		p_halbe = (marr * (looks2 - n)) / (2 * n)
		q = looks * marr * amp / n
		out[index] = -p_halbe[index] + sqrt(p_halbe[index]^2 + q[index])
	endif
	err = where(finite(out) eq 0,anz)
   if anz ne 0 then out[err]=0.0
	return,(out > 0)
end

function mbox,n,anz
	box = intarr(n*n)
	for i=0,n-1 do box[n*i] = (findgen(n)-n/2)+anz*(i-n/2)
	return,box
end

pro speck_gammamap,CALLED = called, SMM = smm, LOOKS=looks
	common rat, types, file, wid, config

	if not keyword_set(called) then begin             ; Graphical interface
		main = WIDGET_BASE(GROUP_LEADER=wid.base,row=3,TITLE='Gamma MAP Speckle Filter',/floating,/tlb_kill_request_events,/tlb_frame_attr)
		field1   = CW_FIELD(main,VALUE=7,/integer,  TITLE='Filter boxsize        : ',XSIZE=3)
		field2   = CW_FIELD(main,VALUE='1.0',/float,TITLE='Effective No of Looks : ',XSIZE=3)
		buttons  = WIDGET_BASE(main,column=3,/frame)
		but_ok   = WIDGET_BUTTON(buttons,VALUE=' OK ',xsize=80,/frame)
		but_canc = WIDGET_BUTTON(buttons,VALUE=' Cancel ',xsize=60)
		but_info = WIDGET_BUTTON(buttons,VALUE=' Info ',xsize=60)
		WIDGET_CONTROL, main, /REALIZE, default_button = but_ok,tlb_get_size=toto
		pos = center_box(toto[0],drawysize=toto[1])
		widget_control, main, xoffset=pos[0], yoffset=pos[1]


		repeat begin
			event = widget_event(main)
			if event.id eq but_info then begin               ; Info Button clicked
				infotext = ['GAMMA MAP SPECKLE FILTER',$
				' ',$
				'RAT module written 10/2003 by Andre Lehmann',$
				' ',$
				'further information:',$
				'C.Oliver / S.Quegan ',$
				'Understanding Synthetic Aperture Radar Images',$
				'Norwood, MA: Artech House, pp.166-167, 1998']
				info = DIALOG_MESSAGE(infotext, DIALOG_PARENT = main, TITLE='Information')
			end
		endrep until (event.id eq but_ok) or (event.id eq but_canc) or tag_names(event,/structure_name) eq 'WIDGET_KILL_REQUEST'
		widget_control,field1,GET_VALUE=smm
		widget_control,field2,GET_VALUE=looks
		widget_control,main,/destroy                        ; remove main widget
		if event.id ne but_ok then return                   ; OK button _not_ clicked
	endif else begin                                       ; Routine called with keywords
		if not keyword_set(smm) then smm = 7                ; Default values
		if not keyword_set(looks) then looks = 1.0
	endelse

; Error handling

	if smm lt 3 then begin                                 ; Wrong box size ?
		error = DIALOG_MESSAGE("Boxsize has to be >= 3", DIALOG_PARENT = wid.base, TITLE='Error',/error)
		return
	endif
	if looks lt 1.0 then begin                              ; Looks to small ?
		error = DIALOG_MESSAGE("Looks have to be >= 1.0", DIALOG_PARENT = wid.base, TITLE='Error',/error)
		return
	endif

; change mousepointer

	WIDGET_CONTROL,/hourglass

; undo function
   undo_prepare,outputfile,finalfile,CALLED=CALLED

; handling of complex and amplitude input data
	
	ampflag = 0
	if file.var eq 6 or file.var eq 9 then begin             ; Wrong variable type?
		error = DIALOG_MESSAGE(["Image is complex and has to","be converted to float first"], /cancel, DIALOG_PARENT = wid.base, TITLE='Warning')
		if error eq "Cancel" then return else complex2abs,/called
		if wid.cancel eq 1 then return
		ampflag = 1
	endif
	if file.type eq 100 then ampflag = 1
	
; read / write header

	head = 1l
	rrat,file.name,ddd,header=head,info=info,type=type
	srat,outputfile,eee,header=head,info=info,type=type

; calculating preview size and number of blocks

	bs = config.blocksize
	overlap = (smm + 1) / 2
	calc_blocks_overlap,file.ydim,bs,overlap,anz_blocks,bs_last
	blocksizes = intarr(anz_blocks)+bs
	blocksizes[anz_blocks-1] = bs_last

	ypos1 = 0                       ; block start
	ypos2 = bs - overlap            ; block end

	byt=[0,1,4,8,4,8,8,0,0,16,0,0,4,4,8,8]	  ; bytelength of the different variable typos

; pop up progress window

	progress,Message='Gamma MAP Speckle Filter...',/cancel_button

;start block processing

	for i = 0, anz_blocks - 1 do begin
		progress,percent=(i+1)*100.0/anz_blocks,/check_cancel
		if wid.cancel eq 1 then return

		block = make_array([file.vdim,file.zdim,file.xdim,blocksizes[i]],type=file.var)
		readu,ddd,block
; -------- THE FILTER ----------
		if ampflag eq 1 then block = block^2
		for j=0,file.vdim-1 do for k=0,file.zdim-1 do block[j,k,*,*] = gammamap(reform(block[j,k,*,*]),smm,looks=looks)
		if ampflag eq 1 then block = sqrt(block)
; -------- THE FILTER ----------
		if i eq anz_blocks-1 then ypos2 = bs_last
		writeu,eee,block[*,*,*,ypos1:ypos2-1]
		ypos1 = overlap
		point_lun,-ddd,file_pos
		point_lun,ddd,file_pos - 2 * overlap * file.vdim * file.zdim * file.xdim * byt[file.var]
	endfor
	free_lun,ddd,eee

; update file information

	file.name = finalfile
	file_move,outputfile,finalfile,/overwrite

        evolute,'Speckle filtering (Gamma-MAP)'

; generate preview

	if not keyword_set(called) then begin
		generate_preview
		update_info_box
	endif


end


