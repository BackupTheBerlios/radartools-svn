;------------------------------------------------------------------------
; RAT Module: evolute
;
; written by    : Maxim Neumann
; last revision : 17.Oct.2005
;------------------------------------------------------------------------
; 
;------------------------------------------------------------------------
; PARAMETERS:
;   curr_step: will be added to the evolution of the file
;   small:     will be added to the file.info text (optional)
;------------------------------------------------------------------------
; EXAMPLE:
;   evolute,'RefLee Speckle box'+strcompress(smm),SMALL='rLee'
;------------------------------------------------------------------------


pro evolute,curr_step, SMALL=small, NO_TIMESTAMP=NO_TIMESTAMP
  common rat
  common rit, parstruct, evolution
  
  if ~keyword_set(NO_TIMESTAMP) then $
     curr_step = strjoin(curr_step)+' TIMESTAMP: '+systime() $
  else curr_step=strjoin(curr_step)
  if n_elements(evolution) eq 1 && strlen(evolution) eq 0 then $
     evolution = [curr_step] $
  else evolution = [evolution, curr_step]

  if n_elements(small) eq 1 then file.info += ' '+small

end
