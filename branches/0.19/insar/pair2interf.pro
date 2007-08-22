;------------------------------------------------------------------------
; RAT Module: pair2interf
;
; written by    : Andreas Reigber
; last revision : 14.Mar.2003
;------------------------------------------------------------------------
; Interferometric pair to complex interferogram conversion
;------------------------------------------------------------------------

pro pair2interf,CALLED=called
	common rat, types, file, wid, config

; check if array is complex

	if file.type ne 300 then begin
		error_button = DIALOG_MESSAGE('Data is not an interferometric pair', DIALOG_PARENT = wid.base, TITLE='Error',/ERROR)
		return
	endif

; change mousepointer

	WIDGET_CONTROL,/hourglass

; undo function
   undo_prepare,outputfile,finalfile,CALLED=CALLED

; read / write header

	head = 1l
	rrat,file.name,ddd,header=head,info=info,type=type		
	head = [2l,file.xdim,file.ydim,file.var]
	srat,outputfile,eee,header=head,info=info,type=301l		
	
; calculating preview size and number of blocks

	bs = config.blocksize
	calc_blocks_normal,file.ydim,bs,anz_blocks,bs_last 
	blocksizes = intarr(anz_blocks)+bs
	blocksizes[anz_blocks-1] = bs_last
	
; pop up progress window

	progress,Message='Calculating interferogram...',/cancel_button

;start block processing

	for i=0,anz_blocks-1 do begin   ; normal blocks
		progress,percent=(i+1)*100.0/anz_blocks,/check_cancel
		if wid.cancel eq 1 then return


		block = make_array([file.vdim,file.zdim,file.xdim,blocksizes[i]],type=file.var)
		readu,ddd,block
; -------- THE FILTER ----------
		writeu,eee,block[0,0,*,*] * conj(block[0,1,*,*])
; -------- THE FILTER ----------
	endfor
	free_lun,ddd,eee

; update file information
	
	file_move,outputfile,finalfile,/overwrite

	file.name = finalfile
	file.dim  = 2l
	file.zdim = 1l
	file.type = 301l

; generate preview

	if not keyword_set(called) then begin
		generate_preview
		update_info_box
	endif
end
