;------------------------------------------------------------
; Example filter subroutine (EXAMPLE)
; -> possibly you might want something more intelligent
;------------------------------------------------------------

function my_filter,arr,para1,para2
	return,arr*para1+para2
end





;------------------------------------------------------------
;------------------------------------------------------------
;------------------------------------------------------------
;------------------------------------------------------------
; Main RAT module, to be called by rat.pro
; -> don't forget to:
;    add it to the 'compile.pro' in the respective subdirectory
;    change 'rat.pro' to be able to call the new module
;------------------------------------------------------------
;------------------------------------------------------------
;------------------------------------------------------------
;------------------------------------------------------------

pro template_overlap,CALLED = called, PARA1 = para1, PARA2 = para2

;------------------------------------------------------------
; Global variables of RAT (FIXED)
; 
; Important:
;
; file.xdim = horizontal size of image
; file.ydim = vertical size of image
; file.zdim = number of layers, 1st matrix dimension
; file.vdim = used in matrix represenation for 2nd matrix dimension
; file.var  = IDL variable type, following the values returned by the size() command
; file.type = RAT data type, for details have a look in definitions.pro
;------------------------------------------------------------

	common rat, types, file, wid, config

;------------------------------------------------------------
; Error Handling 1 (EXAMPLE)
; -> check if the input file is suitable for the routine
;------------------------------------------------------------

	if file.type ne 100 then begin
		error_button = DIALOG_MESSAGE(['Data have to be a SAR amplitude data'], DIALOG_PARENT = wid.base, TITLE='Error',/ERROR)
		return
	endif

;------------------------------------------------------------
; Graphical interface mode (FIXED+EXAMPLE)
; -> used only if the keyword /called is not set
;    this is important as possibly other routines want to use
;    your routine as a batch process
;------------------------------------------------------------

	if not keyword_set(called) then begin            
		main = WIDGET_BASE(GROUP_LEADER=wid.base,row=2,TITLE='Template Overlap',/modal)
		field1   = CW_FIELD(main,VALUE=7,/integer,TITLE='Parameter 1     : ',XSIZE=3)
		field2   = CW_FIELD(main,VALUE=7,/integer,TITLE='Parameter 2     : ',XSIZE=3)
		buttons  = WIDGET_BASE(main,column=3,/frame)
		but_ok   = WIDGET_BUTTON(buttons,VALUE=' OK ',xsize=80,/frame)
		but_canc = WIDGET_BUTTON(buttons,VALUE=' Cancel ',xsize=60)
		but_info = WIDGET_BUTTON(buttons,VALUE=' Info ',xsize=60)
		WIDGET_CONTROL, main, /REALIZE, default_button = but_canc,tlb_get_size=toto
		pos = center_box(toto[0],drawysize=toto[1])
		widget_control, main, xoffset=pos[0], yoffset=pos[1]

	
		repeat begin
			event = widget_event(main)
			if event.id eq but_info then begin               ; Info Button clicked
				infotext = ['Template Overlap',$
				' ',$
				'RAT module written 01/2004 by Andreas Reigber']
				info = DIALOG_MESSAGE(infotext, DIALOG_PARENT = main, TITLE='Information')
			end
		endrep until (event.id eq but_ok) or (event.id eq but_canc) 
		widget_control,field1,GET_VALUE=para1
		widget_control,field2,GET_VALUE=para2
		widget_control,main,/destroy
		if event.id ne  but_ok then return                    ; OK button _not_ clicked
	endif else begin                                         ; Routine called with keywords

;------------------------------------------------------------
; Batch mode (FIXED+EXAMPLE)
; -> take parameters from keywords or use default values
;------------------------------------------------------------

		if not keyword_set(para1) then para1 = 7              ; Default values
		if not keyword_set(para2) then para2 = 7              ; Default values
	endelse

;------------------------------------------------------------
; Error Handling 2 (EXAMPLE)
; -> check validity of parameters
;------------------------------------------------------------

	if para1 le 1 then begin                                   ; Wrong box size ?
		error = DIALOG_MESSAGE("Parameter 1 has to be > 1", DIALOG_PARENT = wid.base, TITLE='Error',/error)
		return
	endif

;------------------------------------------------------------
; change mousepointer to hourglass (FIXED)
;------------------------------------------------------------

	WIDGET_CONTROL,/hourglass

;------------------------------------------------------------
; Undo function (FIXED)
; -> save actual data set in temporary directory
;------------------------------------------------------------

; undo function
   undo_prepare,outputfile,finalfile,CALLED=CALLED


;------------------------------------------------------------
; Error Handling 3 (EXAMPLE)
; -> When input data is complex, convert it to floating point
;------------------------------------------------------------

	if file.var eq 6 or file.var eq 9 then begin         
		error = DIALOG_MESSAGE(["Image is complex and has to","be converted to float first"], /cancel, DIALOG_PARENT = wid.base, TITLE='Warning')
		if error eq "Cancel" then return
		complex2abs,/called
	endif


;------------------------------------------------------------
; Read / write file header (FIXED+EXAMPLE)
; -> If the parameters of the output data are not identical
;    to the input data, a different (correct) header has to
;    be written
;------------------------------------------------------------

	head = 1l
	rrat,file.name,ddd,header=head,info=info,type=type		
	srat,outputfile,eee,header=head,info=info,type=type		
		

;------------------------------------------------------------
; Calculating preview size and number of blocks (FIXED)
; -> overlap specifies the overlap between the vertical blocks
;    at the end, blocksizes contains the individual blocksizes
;------------------------------------------------------------
		
	bs = config.blocksize
	overlap = (smm + 1) / 2
	calc_blocks_overlap,file.ydim,bs,overlap,anz_blocks,bs_last 
	blocksizes = intarr(anz_blocks)+bs
	blocksizes[anz_blocks-1] = bs_last

	ypos1 = 0                       ; block start
	ypos2 = bs - overlap            ; block end

	byt=[0,1,4,8,4,8,8,0,0,16,0,0,4,4,8,8]	  ; bytelength of the different variable typos

;------------------------------------------------------------
; Pop up progress window (FIXED)
;------------------------------------------------------------

	progress,Message='Median Speckle Filter...',/cancel_button

;------------------------------------------------------------
; Start block processing (FIXED)
;------------------------------------------------------------

	for i=0,anz_blocks-1 do begin   
		progress,percent=(i+1)*100.0/anz_blocks,/check_cancel
		if wid.cancel eq 1 then return


;------------------------------------------------------------
; Create empty input array and read it from input file (FIXED)
; -> after reading the array is 4-dimensional. To get rid of
;    leading empty dimensions use the reform() command
;------------------------------------------------------------

		block = make_array([file.vdim,file.zdim,file.xdim,blocksizes[i]],type=file.var)
		readu,ddd,block

;------------------------------------------------------------
;------------------------------------------------------------
; -------- THE FILTER ----------
;
;  Here you can do something with the data (EXAMPLE)
;
; -------- THE FILTER ----------
;------------------------------------------------------------
;------------------------------------------------------------

		for j=0,file.vdim-1 do for k=0,file.zdim-1 do block[j,k,*,*] = my_filter(reform(block[j,k,*,*]),para1,para2)

;------------------------------------------------------------
; Write block and jump back in input file due to block overlap (FIXED)
;------------------------------------------------------------

		if i eq anz_blocks-1 then ypos2 = bs_last
		writeu,eee,block[*,*,*,ypos1:ypos2-1]
		ypos1 = overlap
		point_lun,-ddd,file_pos
		point_lun,ddd,file_pos - 2 * overlap * file.vdim * file.zdim * file.xdim * byt[file.var]
	endfor
	free_lun,ddd,eee

;------------------------------------------------------------
; Update file information (FIXED)
; -> If the parameters of the output data are not identical
;    to the input data, here all the new data parameters are
;    to be set. Take care to write also a correct file header
;------------------------------------------------------------
	
	file.name = finalfile
	file_move,outputfile,finalfile,/overwrite
	
;------------------------------------------------------------
; For the text-history of the changes of the data files.
;------------------------------------------------------------

        evolute,'A short description what this procedure changes. Add the most important parameters'

;------------------------------------------------------------
; Generate and display preview image and info-text (FIXED)
;------------------------------------------------------------

	if not keyword_set(called) then begin
		generate_preview
		update_info_box
	endif
	
;------------------------------------------------------------
; Return to main program (FIXED)
;------------------------------------------------------------

end
