;------------------------------------------------------------------------
; RAT Module: decomp_entalpani
;
; written by    : Andreas Reigber
; last revision : 20.Mar.2003
;------------------------------------------------------------------------
; Calculates Entropy / Alpha Anisotropy
;------------------------------------------------------------------------



pro decomp_entalpani,CALLED=called,METHOD = method
	common rat, types, file, wid, config

; check if array is usable

	if file.type ne 214 and file.type ne 220 and file.type ne 221 then begin
		error_button = DIALOG_MESSAGE(['Input data have to be a [C] matrix','[T] matrix or an eigendecomposition.'], DIALOG_PARENT = wid.base, TITLE='Error',/ERROR)
		return
	endif

	if not keyword_set(called) then begin             ; Graphical interface
		main = WIDGET_BASE(GROUP_LEADER=wid.base,row=3,TITLE='Entropy / Alpha / Anisotropy Calculation',/floating,/tlb_kill_request_events,/tlb_frame_attr)
		field2 = widget_label(main,value='Select type of alpha angle:')
		field1 = CW_BGROUP(main,['Mean alpha','Dominant alpha'],/column,/exclusive,set_value=0)
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
				infotext = ['ENTROPY ALPHA ANISOTROPY CALCULATION V2.0',$
				' ',$
				'RAT module written 02/2005 by Andreas Reigber']
				info = DIALOG_MESSAGE(infotext, DIALOG_PARENT = main, TITLE='Information')
			end
		endrep until (event.id eq but_ok) or (event.id eq but_canc) or tag_names(event,/structure_name) eq 'WIDGET_KILL_REQUEST'
		widget_control,field1,GET_VALUE=method               ; read widget fields
		widget_control,main,/destroy                        ; remove main widget
		if event.id ne but_ok then return                   ; OK button _not_ clicked
	endif else begin                                       ; Routine called with keywords
		if not keyword_set(method) then method = 0              ; Default values
	endelse
; ----------------------

	WIDGET_CONTROL,/hourglass

; undo function
   undo_prepare,outputfile,finalfile,CALLED=CALLED
	
	if file.type eq 220 then begin             ; Wrong variable type?
		if not keyword_set(called) then dummy = DIALOG_MESSAGE(["Performing necessary preprocessing step:","Tranformation to Pauli representation"], DIALOG_PARENT = wid.base, /information)
		c_to_t,/called
	endif

	if file.type eq 221 then begin             ; Wrong variable type?
		if not keyword_set(called) then dummy = DIALOG_MESSAGE(["Performing necessary preprocessing step:","Eigenvector Decomposition"], DIALOG_PARENT = wid.base, /information)
		decomp_eigen,/called
	endif

; read / write header

	head = 1l
	rrat,file.name,ddd,header=head,info=info,type=type		
	srat,outputfile,eee,header=[3l,file.zdim < 3,file.xdim,file.ydim,4l],info=info,type=233l		
	
; calculating preview size and number of blocks

	bs = config.blocksize
	calc_blocks_normal,file.ydim,bs,anz_blocks,bs_last 
	blocksizes = intarr(anz_blocks)+bs
	blocksizes[anz_blocks-1] = bs_last

; pop up progress window

	progress,Message='H/a/A decomposition...',/cancel_button

	index = indgen(file.zdim < 3)
	for i=0,anz_blocks-1 do begin
		progress,percent=(i+1)*100.0/anz_blocks,/check_cancel
		if wid.cancel eq 1 then return

		block  = make_array([file.vdim,file.zdim,file.xdim,blocksizes[i]],type=6l)
		oblock = make_array([file.zdim < 3,file.xdim,blocksizes[i]],type=4l)
		readu,ddd,block
		for k=0,file.xdim-1 do begin
			for l=0,blocksizes[i]-1 do begin	
				ew = reform(abs(block[file.vdim-1,*,k,l]))
				ev = reform(abs(block[0:file.vdim-2,*,k,l]))
				
				if file.zdim eq 4 then begin
					ew = ew[0:2]
					ev = ev[0:2,0:2]
				endif
				
				pi = ew / total(ew)
				oblock[0,k,l] = total(-pi*alog(pi)/alog(file.zdim))						; entropy
				if method eq 0 then oblock[1,k,l] = total(acos(abs(ev[0,index]))*pi[index]) $ ; mean alpha
									else oblock[1,k,l] = acos(abs(ev[0,0]))	
				if file.zdim gt 2 then oblock[2,k,l] = (ew[1]-ew[2])/(ew[1]+ew[2])	; anisotropy	
			endfor
		endfor
		
		aux = where(finite(oblock) eq 0,anz)  ; eliminate nan's
   	if anz ne 0 then oblock[aux]=0.0
		
		writeu,eee,oblock
	endfor
	free_lun,ddd,eee
	
; update file information

	file_move,outputfile,finalfile,/overwrite
	file.name = finalfile
	file.type = 233l
	file.vdim = 1l
	file.zdim = 3l
	file.dim  = 3l
	file.var  = 4l
	
; generate preview

	if not keyword_set(called) then begin
		generate_preview
		update_info_box
	endif	
end
