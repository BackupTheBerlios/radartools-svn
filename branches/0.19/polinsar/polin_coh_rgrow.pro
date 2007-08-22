;------------------------------------------------------------------------
; RAT Module: polin_coh_rgrow
;
; written by       : Maxim Neumann
; last revision    : 08/2006
;------------------------------------------------------------------------
; Multibaseline coherence calculation using region growing
;------------------------------------------------------------------------

pro polin_coh_rgrow,CALLED = called
  common rat, types, file, wid, config

  if ~(file.type ge 500 && file.type le 513) then begin
     error = DIALOG_MESSAGE("This is wrong data type.", $
                            DIALOG_PARENT = wid.base, TITLE='Error',/error)
     return
  endif

; undo function
  undo_prepare,outputfile,finalfile,CALLED=CALLED

  speck_polidan, /CALLED, /GUI
  polin_coh_mean, smmx=1,smmy=1, /CALLED

  evolute,'Multibaseline coherence estimation. 1x1'

; generate preview
  if not keyword_set(called) then begin
     generate_preview
     update_info_box
  endif else progress,/destroy
end
