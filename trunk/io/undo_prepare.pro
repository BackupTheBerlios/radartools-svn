;------------------------------------------------------------------------
; RAT Module: undo_prepare
;
; written by    : Maxim Neumann
; last revision : 18.Oct.2005
;------------------------------------------------------------------------
; 
;------------------------------------------------------------------------
; PARAMETERS:
;   
;------------------------------------------------------------------------
; EXAMPLE:
;   undo_prepare,outputfile,finalfile,CALLED=CALLED
;------------------------------------------------------------------------


pro undo_prepare,outputfile,finalfile,CALLED=CALLED, OPEN_RAT=OPEN_RAT
  common rat

  outputfile = config.tempdir+config.workfile2
  finalfile  = config.tempdir+config.workfile1

; undo function
  if ~keyword_set(called) then begin
     if ~keyword_set(OPEN_RAT) && file.name eq finalfile then begin
        file_copy,file.name,config.tempdir+config.workfile3,/overwrite
        config.undofile = config.tempdir+config.workfile3
     endif else config.undofile = file.name
     save_rit,filename=config.undofile,/UNDO_PREPARE
     widget_control,wid.button_undo,set_value=config.imagedir+'undo.bmp',/BITMAP

     config.redofile = ''
     widget_control,wid.button_redo,set_value=config.imagedir+'redo2.bmp',/BITMAP
  endif

end

