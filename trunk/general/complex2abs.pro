;------------------------------------------------------------------------
; RAT Module: complex2abs
;
; last revision : 14.Mar.2003
; written by    : Andreas Reigber
;------------------------------------------------------------------------
; Transform complex to its absolute value            
;------------------------------------------------------------------------


pro complex2abs,CALLED=called
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

	progress,Message='Transform Complex -> Amplitude...',/cancel_button

;start block processing

	for i=0,anz_blocks-1 do begin   ; normal blocks
		progress,percent=(i+1)*100.0/anz_blocks,/check_cancel
		if wid.cancel eq 1 then return

		block = make_array([file.vdim,file.zdim,file.xdim,blocksizes[i]],type=file.var)
		readu,ddd,block
		writeu,eee,abs(block)
	endfor

; update file information

	file.name = finalfile
	file.var  = 4l
	if file.type eq 101 then file.type = 100l
	if file.type eq 54 then file.type = 51l
	if file.type eq 53 then file.type = 50l
	free_lun,ddd,eee
	file_move,outputfile,finalfile,/overwrite

; generate preview

	if not keyword_set(called) then begin
		generate_preview
		update_info_box
	endif
	
end
