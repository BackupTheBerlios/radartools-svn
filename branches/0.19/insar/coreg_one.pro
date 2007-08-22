;------------------------------------------------------------------------
; RAT Module: coreg_one
;
; written by    : Andreas Reigber
; last revision : 13. Oct 2004
;------------------------------------------------------------------------
; Interferometric coregistration based on amplitude correlation
; one value for the whole image only
;------------------------------------------------------------------------


function coreg_amp,arr1,arr2,k
	bsx = (size(arr1))[1]
	bsy = (size(arr1))[2]
	auxcor = abs(fft(fft(abs(arr1),-1)*conj(fft(abs(arr2),-1)),+1))
	aux = max(auxcor, auxpos )      
	k = aux / mean(auxcor)
	offsetx = auxpos mod bsx
	offsety = auxpos  /  bsx
	if (offsetx gt bsx/2) then offsetx = offsetx-bsx
	if (offsety gt bsy/2) then offsety = offsety-bsy
	return,[offsetx,offsety]
end

pro coreg_one,CALLED = called, OFFSETX = offsetx, OFFSETY = offsety
	common rat, types, file, wid, config

	if file.type ne 300 and file.type ne 301 and file.type ne 302 then begin                   
		error = DIALOG_MESSAGE("This is not an interferogram ", DIALOG_PARENT = wid.base, TITLE='Error',/error)
		return
	endif
	
	if not keyword_set(offsetx) then offsetx = 0 				 ; Default values
	if not keyword_set(offsety) then offsety = 0
	
	if not keyword_set(called) then begin             ; Graphical interface
		main = WIDGET_BASE(GROUP_LEADER=wid.base,row=4,TITLE='Course image registration',/floating,/tlb_kill_request_events,/tlb_frame_attr)
		manual = WIDGET_BASE(main,row=3,/frame)
		dummy  = widget_label(manual,value='Manual offset correction')
		field1 = CW_FIELD(manual,VALUE=offsetx,/integer,TITLE='Offset in x : ',XSIZE=5)
		field2 = CW_FIELD(manual,VALUE=offsety,/integer,TITLE='Offset in y : ',XSIZE=5)
		auto   = WIDGET_BASE(main,row=4,/frame)
		dummy  = widget_label(auto,value='Automatic Offset estimation')
		field3 = CW_FIELD(auto,VALUE=128,/integer,TITLE='Maximum offset in x to check : ',XSIZE=5)
		field4 = CW_FIELD(auto,VALUE=2048,/integer,TITLE='Maximum offset in y to check : ',XSIZE=5)
		but_estimate = WIDGET_BUTTON(auto,VALUE=' Start estimation (memory intensive)')
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
				infotext = ['COURSE IMAGE COREGISTRATION',$
				' ',$
				'RAT module written 2003 by Andreas Reigber']
				info = DIALOG_MESSAGE(infotext, DIALOG_PARENT = main, TITLE='Information')
			end
		if (event.id eq but_estimate) then begin
			WIDGET_CONTROL,/hourglass
			widget_control,field3,get_value=maxoff_x
			widget_control,field4,get_value=maxoff_y

			bsx = 2                      ; search automatically for good blocksize
			while 2l^bsx lt 2*maxoff_x do bsx++  
			if 2^bsx gt file.xdim then while 2l^bsx gt file.xdim do bsx--
			bsx = 2^bsx
			bsy = 2                      ; search automatically for good blocksize
			while 2l^bsy lt 2*maxoff_y do bsy++  
			if 2^bsy gt file.ydim then while 2l^bsy gt file.ydim do bsy--
			bsy = 2^bsy

			progress,Message='Estimating offset...',/cancel_button
			
			arr = make_array([file.zdim,bsx,bsy],type=file.var)
			for i=0l,bsy/bsx-1 do begin
				progress,percent=(i+1)*100.0/(bsy/bsx-1),/check_cancel
		if wid.cancel eq 1 then return

				ypos = file.ydim/2 - bsy/2 + i*bsx
				rrat,file.name,dummy,block=[file.xdim/2-bsx/2,ypos,bsx,bsx]
				arr[*,*,i*bsx:i*bsx+bsx-1] = dummy
			endfor

			ret = coreg_amp(reform(arr[0,*,*]),reform(arr[1,*,*]),k)			
			offsetx = ret[0]
			offsety = ret[1]
			
			progress,/destroy

			widget_control,field1,set_value=offsetx
			widget_control,field2,set_value=offsety
		endif
		
		endrep until (event.id eq but_ok) or (event.id eq but_canc) or tag_names(event,/structure_name) eq 'WIDGET_KILL_REQUEST'
		widget_control,field1,GET_VALUE=offsetx             ; read widget fields
		widget_control,field2,GET_VALUE=offsety
		widget_control,main,/destroy                        ; remove main widget
		if event.id ne but_ok then return                   ; OK button _not_ clicked
	endif else begin                                       ; Routine called with keywords
		if not keyword_set(offsetx) then offsetx = 0              ; Default values
		if not keyword_set(offsety) then offsety = 0
	endelse
	
; change mousepointer

	WIDGET_CONTROL,/hourglass

; undo function
   undo_prepare,outputfile,finalfile,CALLED=CALLED

; read / write header

	head = 1l
	rrat,file.name,ddd,header=head,info=info,type=type		
	srat,outputfile,eee,header=head,info=info,type=type		
		
; calculating preview size and number of blocks

	bs = config.blocksize > 4*floor(abs(offsety) + 1) 
	overlap = floor(abs(offsety)) + 1

	calc_blocks_overlap,file.ydim,bs,overlap,anz_blocks,bs_last 
	blocksizes = intarr(anz_blocks)+bs
	blocksizes[anz_blocks-1] = bs_last

	ypos1 = 0                       ; block start
	ypos2 = bs - overlap            ; block end

	byt=[0,1,4,8,4,8,8,0,0,16,0,0,4,4,8,8]	  ; bytelength of the different variable typos
	
; pop up progress window

	progress,Message='Shifting...',/cancel_button

;start block processing

	for i=0,anz_blocks-1 do begin   
		progress,percent=(i+1)*100.0/anz_blocks,/check_cancel
		if wid.cancel eq 1 then return


		block = make_array([file.zdim,file.xdim,blocksizes[i]],type=file.var)
		readu,ddd,block

; -------- THE FILTER ----------
		block[1,*,*] = shift(block[1,*,*],0,offsetx,offsety)
; -------- THE FILTER ----------

		if i eq anz_blocks-1 then ypos2 = bs_last
		writeu,eee,block[*,*,ypos1:ypos2-1]
		ypos1 = overlap
		point_lun,-ddd,file_pos
		point_lun,ddd,file_pos - 2 * overlap * file.vdim * file.zdim * file.xdim * byt[file.var]
	endfor
	free_lun,ddd,eee

; update file information
		
	file_move,outputfile,finalfile,/overwrite
	file.name = finalfile

; generate preview

	if not keyword_set(called) then begin
		generate_preview
		update_info_box
	endif
end
