;------------------------------------------------------------------------
; RAT Module: open_rit
;
; written by    : Maxim Neumann
; last revision : 17.Oct.2005
;------------------------------------------------------------------------
; Read the parstruct values from the rit file
;------------------------------------------------------------------------
; PARAMETERS:
;------------------------------------------------------------------------
; EXAMPLE:
;------------------------------------------------------------------------

pro open_rit, FILENAME=FILENAME_orig,EMPTY=EMPTY
  common rat
  common channel, channel_names, channel_selec, color_flag, palettes, pnames
  common rit, pars,evolution    ; pars== parameters structure ==parstruct

  if keyword_set(EMPTY) then begin
     for i=0,n_tags(pars)-1 do $
        ptr_free,pars.(i)
     for i=0,n_tags(pars)-1 do $
        pars.(i) = ptr_new()
     evolution = ['']
     palettes[0,*,*] = [[bindgen(256)],[bindgen(256)],[bindgen(256)]]
     palettes[1,*,*] = palettes[0,*,*]
     return
  endif

  if n_elements(FILENAME_orig) eq 0 then FILENAME = file.name $
  else FILENAME = FILENAME_orig
  FILENAME = strmid(FILENAME,0,strlen(FILENAME)-4)+'.rit'

;;; system parameters
  par_nr    = n_tags(pars)
  par_names = tag_names(pars)
  for i=0,par_nr-1 do begin
     ptr_free,pars.(i)
     rit_read, FILENAME,par_names[i],val, STATUS=STATUS
     if status eq 0 then $
        pars.(i) = ptr_new(val) $
     else pars.(i) = ptr_new()
  endfor

;;; evolution
  i = 0
  evolution = ['']
  repeat begin
     rit_read,FILENAME,'RAT_EVOLUTION_'+strcompress(i++,/R),ev,STATUS=status
     if status eq 0 then begin
        if n_elements(evolution) eq 1 && strlen(evolution) eq 0 then $
           evolution = [ev] $
        else evolution = [evolution, ev]
     endif
  endrep until status ne 0

;;; palette  --  read palette information

  palettes[0,*,*] = palette_read(filename=filename)
  palettes[1,*,*] = palettes[0,*,*]
	
;;; set to b/w linear if palette is empty - anderl 01/07	

	if max(palettes[0,*,*]) eq 0 then begin
		palettes[0,*,*] = palettes[2,*,*]  
		palettes[1,*,*] = palettes[2,*,*]  
	endif

end
