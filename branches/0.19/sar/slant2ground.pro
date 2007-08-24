;------------------------------------------------------------------------
; RAT - Radar Tools
;------------------------------------------------------------------------
; RAT Module: slant2ground
; written by    : Andreas Reigber
; last revision : 14.Mar.2003
; Generic slant-range to ground-range projection
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

pro slant2ground,CALLED=called
	common rat, types, file, wid, config

	if not keyword_set(called) then begin             ; Graphical interface
		main = WIDGET_BASE(GROUP_LEADER=wid.base,row=3,TITLE='Slant Range Projection',/floating,/tlb_kill_request_events,/tlb_frame_attr)
		field1 = CW_FIELD(main,VALUE=0.0,/floating,TITLE='Sensor height           : ',XSIZE=5)
		field2 = CW_FIELD(main,VALUE=0.0,/floating,TITLE='Minimum range distance  : ',XSIZE=5)
		field3 = CW_FIELD(main,VALUE=0.0,/floating,TITLE='Range pixel spacing     : ',XSIZE=5)
		field4 = CW_FIELD(main,VALUE=0.0,/floating,TITLE='Output pixel spacing    : ',XSIZE=5)
		buttons = WIDGET_BASE(main,column=3,/frame)
		but_ok   = WIDGET_BUTTON(buttons,VALUE=' OK ',xsize=80,/frame)
		but_canc = WIDGET_BUTTON(buttons,VALUE=' Cancel ',xsize=60)
		but_info = WIDGET_BUTTON(buttons,VALUE=' Info ',xsize=60)
		WIDGET_CONTROL, main, /REALIZE, default_button = but_canc,tlb_get_size=toto
		pos = center_box(toto[0],drawysize=toto[1])
		widget_control, main, xoffset=pos[0], yoffset=pos[1]

		repeat begin                                        ; Event loop
			event = widget_event(main)
			if event.id eq but_info then begin               ; Info Button clicked
				infotext = ['Slant-range to ground range projection',$
				' ',$
				'RAT module written 2003 by Andreas Reigber']
				info = DIALOG_MESSAGE(infotext, DIALOG_PARENT = main, TITLE='Information')
			end
		endrep until (event.id eq but_ok) or (event.id eq but_canc) or tag_names(event,/structure_name) eq 'WIDGET_KILL_REQUEST'
		widget_control,field1,GET_VALUE=h0               ; read widget fields
		widget_control,field2,GET_VALUE=rd
		widget_control,field3,GET_VALUE=psin
		widget_control,field4,GET_VALUE=psout
		widget_control,main,/destroy                        ; remove main widget
		if event.id ne but_ok then return                   ; OK button _not_ clicked
	endif 

; calculate interpolation function
	
	range = rd + dindgen(file.xdim)*psin
	theta = acos(h0 / range)
	yin   = sqrt(range^2 - h0^2)
	aux   = where(finite(yin) eq 0,anz)
	if anz gt 0 then yin[aux] = 0.0
	
	y0    = yin[0]
	y1    = yin[file.xdim-1]
	anz_out = floor((y1 - y0) / psout)

	yout  = y0 + findgen(anz_out)*psout
	
	tin   = findgen(file.xdim)
	tout  = interpol(tin,yin,yout)

; change mousepointer

	WIDGET_CONTROL,/hourglass

; undo function
   undo_prepare,outputfile,finalfile,CALLED=CALLED


; read / write header

	head = 1l
	rrat,file.name,ddd,header=head,info=info,type=type		
	head[head[0]-1] = anz_out
	srat,outputfile,eee,header=head,info=info,type=type		
	
; calculating preview size and number of blocks

	bs = config.blocksize
	calc_blocks_normal,file.ydim,bs,anz_blocks,bs_last 
	blocksizes = intarr(anz_blocks)+bs
	blocksizes[anz_blocks-1] = bs_last
	
; pop up progress window

	progress,Message='Slant-Range to Ground Range...',/cancel_button

;start block processing

	for i=0,anz_blocks-1 do begin   ; normal blocks
		progress,percent=(i+1)*100.0/anz_blocks,/check_cancel
		if wid.cancel eq 1 then return

		block  = make_array([file.vdim,file.zdim,file.xdim,blocksizes[i]],type=file.var)
		oblock = make_array([file.vdim,file.zdim,anz_out,blocksizes[i]],type=file.var)
		readu,ddd,block
		for k=0,file.vdim-1 do for l=0,file.vdim-1 do for j=0,blocksizes[i]-1 do $
			oblock[k,l,*,j] = interpolate(reform(block[k,l,*,j]),tout,cubic=-0.5)
		writeu,eee,oblock
	endfor
	free_lun,ddd,eee

; update file information

	file.name = finalfile
	file.xdim = anz_out
	file_move,outputfile,finalfile,/overwrite

; generate preview

	if not keyword_set(called) then begin
		generate_preview
		update_info_box
	endif
end
