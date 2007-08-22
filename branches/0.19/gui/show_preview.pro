;------------------------------------------------------------------------
; RAT Module: show_preview
;
; last revision : 02/2007
; written by    : Maxim Neumann
;------------------------------------------------------------------------
; To show or not to show the preview
;------------------------------------------------------------------------



pro show_preview, ON=ON, OFF=OFF
  common rat

  if keyword_set(ON) then begin ; switch on
     if ~config.show_preview then begin
        config.show_preview = ~config.show_preview
        generate_preview
     endif
  endif else if keyword_set(OFF) then begin ; switch off
     if config.show_preview then begin
        config.show_preview = ~config.show_preview
        generate_preview
     endif
  endif else begin ;;; toggle
;;; to provide this funtionality, include wid.button_show_preview into the system!
     config.show_preview = ~config.show_preview
     generate_preview
     if config.show_preview then $
        widget_control,wid.button_show_preview,set_value=config.imagedir+'show_preview_on.bmp',/BITMAP $
     else $
        widget_control,wid.button_show_preview,set_value=config.imagedir+'show_preview_off.bmp',/BITMAP
  endelse

end
