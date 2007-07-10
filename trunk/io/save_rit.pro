;------------------------------------------------------------------------
; RAT Module: save_rit
;
; written by    : Maxim Neumann
; last revision : 17.Oct.2005
;------------------------------------------------------------------------
; Write the parstruct values to the rit file
;------------------------------------------------------------------------
; PARAMETERS:
;------------------------------------------------------------------------
; EXAMPLE:
;------------------------------------------------------------------------

pro save_rit, FILENAME=FILENAME,UNDO_PREPARE=UNDO_PREPARE
  common rat
  common channel, channel_names, channel_selec, color_flag, palettes, pnames
  common rit, pars,evolution             ; pars== parameters structure ==parstruct

  if n_elements(FILENAME) eq 0 then FILENAME = file.name
  if strmid(filename,strlen(filename)-4) eq '.rat'  then base=file_basename(filename, '.rat')
  if strmid(filename,strlen(filename)-4) eq '.rit'  then base=file_basename(filename, '.rit')
  if strmid(filename,strlen(filename)-5) eq '.mrat' then base=file_basename(filename,'.mrat')
;  filename = file_dirname(filename,/mark)+base+'.rit'
  FILENAME = strmid(FILENAME,0,strlen(FILENAME)-4)+'.rit'


;;; system parameters
;   PN        = ptr_new()
;   par_nr    = n_tags(pars)
;   par_names = tag_names(pars)
;   for i=0,par_nr-1 do $
;      if pars.(i) ne PN then $
;         rit_write,FILENAME,par_names[i],*pars.(i), STATUS=STATUS
;;; evolution
;   if n_elements(evolution) ne 1 || strlen(evolution[0]) ne 0 then $
;      for i=0,n_elements(evolution)-1 do $
;         rit_write,FILENAME,'RAT_EVOLUTION_'+strcompress(i,/R),evolution[i]

  if file_test(filename) then file_delete,/quiet,filename

  if n_elements(evolution) ne 1 || strlen(evolution[0]) ne 0 then $
     rit_write,FILENAME,RAT_PAR=pars,RAT_EVO=evolution,RAT_PALETTE=reform(palettes[0,*,*]) $
  else rit_write,FILENAME,RAT_PAR=pars,RAT_PALETTE=reform(palettes[0,*,*])



;;; save filename and timestamp information
;;; if ~.k(UNDO_PREPARE) then
  
;;; palette  --  save palette information
;;; !always! - because also multi-channel images can have own palettes for
;;;            single channel view
;;;          - and the change from color- to b/w- palette should also be saved
;  palette_write,reform(palettes[0,*,*]),filename=filename

end
