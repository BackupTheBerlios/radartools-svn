;------------------------------------------------------------------------
; RAT Module: redo
;
; written by    : Maxim Neumann
; last revision : 18.Oct.2005
;------------------------------------------------------------------------
; Redo last operation
;------------------------------------------------------------------------
; PARAMETERS:
;   
;------------------------------------------------------------------------
; EXAMPLE:
;   
;------------------------------------------------------------------------



pro redo
  common rat, types, file, wid, config

  if config.redofile ne '' then begin

     config.undofile = file.name
     widget_control,wid.button_undo,set_value=config.imagedir+'undo.bmp',/BITMAP

     if strcmp(file.window_name,file_basename(config.redofile)) $
     then tmp = file.window_name $
     else tmp = file.window_name+' (modified)'

     open_rat,INPUTFILE=config.redofile,/FROM_UNDO
     widget_control,wid.base,base_set_title='RAT - Radar Tools: '+tmp

     config.redofile = ''
     widget_control,wid.button_redo,set_value=config.imagedir+'redo2.bmp',/BITMAP
  endif


end
