;------------------------------------------------------------------------
; RAT Module: complex2pha
;
; last revision : 14.Mar.2003
; written by    : Andreas Reigber
;------------------------------------------------------------------------
; Transform complex to its phase (argument)      
;------------------------------------------------------------------------

pro complex2pha,CALLED=called
	common rat, types, file, wid, config

; check if array is complex

	if file.var ne 6 and file.var ne 9 then begin
		error_button = DIALOG_MESSAGE('Data not complex', DIALOG_PARENT = wid.base, TITLE='Error',/ERROR)
		return
	endif

; change mousepointer

	WIDGET_CONTROL,/hourglass

; undo function
   undo_prepare,outputfile,finalfile,CALLED=CALLED

; read / write header

	head = 1l
	rrat,file.name,ddd,header=head,info=info,type=type		
	head[head[0]+1] = 4l
	srat,outputfile,eee,header=head,info=info,type=type		
	
; calculating preview size and number of blocks

	bs = config.blocksize
	calc_blocks_normal,file.ydim,bs,anz_blocks,bs_last 
	blocksizes = intarr(anz_blocks)+bs
	blocksizes[anz_blocks-1] = bs_last
	
; pop up progress window

	progress,Message='Transform Complex -> Phase...',/cancel_button

;start block processing

	for i=0,anz_blocks-1 do begin   ; normal blocks
		progress,percent=(i+1)*100.0/anz_blocks,/check_cancel
		if wid.cancel eq 1 then return

		block = make_array([file.vdim,file.zdim,file.xdim,blocksizes[i]],type=file.var)
		readu,ddd,block
		writeu,eee,atan(block,/phase)
	endfor

; update file information

	file.name = finalfile
	file.var  = 4l
	if file.dim eq 2 then file.type = 102l
	if file.dim eq 3 then file.type = 524l
	if file.dim eq 4 then file.type = 525l
		
	free_lun,ddd,eee
	file_move,outputfile,finalfile,/overwrite

; generate preview

	if not keyword_set(called) then begin
		generate_preview
		update_info_box
	endif
	
end
