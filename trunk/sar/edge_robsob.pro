;------------------------------------------------------------------------
; RAT - Radar Tools
;------------------------------------------------------------------------
; RAT Module: edge_robsob
; written by    : Bert Wolf (TUB), Matthias Weller (TUB), Andreas Reigber (TUB)
; last revision : 9.Feb.2003
; Sobel and Roberts edge detection
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

pro edge_robsob,CALLED=called,ROBERTS=roberts,SOBEL=sobel
	common rat, types, file, wid, config

; change mousepointer

	WIDGET_CONTROL,/hourglass

; undo function
   undo_prepare,outputfile,finalfile,CALLED=CALLED

; Error Handling

	if file.var eq 6 or file.var eq 9 then begin             ; Wrong variable type?
		error = DIALOG_MESSAGE(["Image is complex and has to","be converted to float first"], /cancel, DIALOG_PARENT = wid.base, TITLE='Warning')
		if error eq "Cancel" then return else complex2abs,/called
	endif

; read / write header

	head = 1l
	rrat,file.name,ddd,header=head,info=info,type=type		
	srat,outputfile,eee,header=head,info=info,type=type		
		
; calculating preview size and number of blocks
	
	bs = config.blocksize
	overlap = 1
	calc_blocks_overlap,file.ydim,bs,overlap,anz_blocks,bs_last 
	blocksizes = intarr(anz_blocks)+bs
	blocksizes[anz_blocks-1] = bs_last

	ypos1 = 0                       ; block start
	ypos2 = bs - overlap            ; block end

	byt=[0,1,4,8,4,8,8,0,0,16,0,0,4,4,8,8]	  ; bytelength of the different variable typos

; pop up progress window

	progress,Message='Detecting Edges...',/cancel_button

;start block processing

	for i=0,anz_blocks-1 do begin   ; loop normal blocks
		progress,percent=(i+1)*100.0/anz_blocks,/check_cancel
		if wid.cancel eq 1 then return

		block = make_array([file.vdim,file.zdim,file.xdim,blocksizes[i]],type=file.var)
		readu,ddd,block
		
; -------- THE FILTER ----------
		if keyword_set(roberts) then for j=0,file.vdim-1 do for k=0,file.zdim-1 do block[j,k,*,*] = roberts(reform(block[j,k,*,*]))
		if keyword_set(sobel) then for j=0,file.vdim-1 do for k=0,file.zdim-1 do block[j,k,*,*] = sobel(reform(block[j,k,*,*]))
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
	file.type = 110l
	file_move,outputfile,finalfile,/overwrite
	
; generate preview

	if not keyword_set(called) then begin
		generate_preview
		update_info_box
	endif
end
