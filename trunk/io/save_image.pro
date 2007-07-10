pro save_image,OUTPUTFILE = outputfile,PNG=png,JPG=jpg,TIFF=tiff
	common rat, types, file, wid, config

	if not keyword_set(outputfile) then begin
		path = config.workdir
		if keyword_set(PNG) then  outputfile = cw_rat_dialog_pickfile(TITLE='Save PNG', DIALOG_PARENT=wid.base, FILTER = '*.png', PATH=path, GET_PATH=path,/overwrite_prompt,/write)
		if keyword_set(JPG) then  outputfile = cw_rat_dialog_pickfile(TITLE='Save JPEG', DIALOG_PARENT=wid.base, FILTER = '*.jpg', PATH=path, GET_PATH=path,/overwrite_prompt,/write)
		if keyword_set(TIFF) then outputfile = cw_rat_dialog_pickfile(TITLE='Save TIFF', DIALOG_PARENT=wid.base, FILTER = '*.tiff', PATH=path, GET_PATH=path,/overwrite_prompt,/write)
		if strlen(outputfile) gt 0 then config.workdir = path
	endif

	if strlen(outputfile) gt 0 then begin

; change mousepointer
	
		WIDGET_CONTROL,/hourglass

;---------------------------------
; Bytscaling
;---------------------------------

		preview,file.name,config.tempdir+config.lookfile,/full 
		rrat,config.tempdir+config.lookfile,image                ; read preview file
		image = float2bytes(image)                               ; do optimised bytscaling
		
		progress,/destroy	

; save to file

		if keyword_set(PNG)  then rat_tv,image,save=outputfile,/png
		if keyword_set(JPG)  then rat_tv,image,save=outputfile,/jpg 
		if keyword_set(TIFF) then rat_tv,image,save=outputfile,/tif
				
;  			if keyword_set(PNG) then WRITE_PNG,outputfile,arr
;  			if keyword_set(JPG) then WRITE_JPEG,outputfile,arr,true=1
;  			if keyword_set(TIFF) then WRITE_TIFF,outputfile,reverse(arr,3)
;		endif
		
	endif
	
end
