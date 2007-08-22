;------------------------------------------------------------------------
; RAT Module: set_par
;
; written by    : Maxim Neumann
; last revision : 17.Oct.2005
;------------------------------------------------------------------------
; 
;------------------------------------------------------------------------
; PARAMETERS:
;------------------------------------------------------------------------
; RETURN: status value:
;   0: everything ok, the value is updated
;   1: error: wrong entry name
;------------------------------------------------------------------------
; EXAMPLE:
;------------------------------------------------------------------------

function set_par, name, value
  common rit, pars             ; pars== parameters structure ==parstruct

  par_names = tag_names(pars)
  i = where(strlowcase(par_names) eq strlowcase(name),whereNr)

;;; error: wrong entry name
  if whereNr lt 1 then $
     return, 1

  ptr_free,pars.(i)
  pars.(i) = ptr_new(value)

  return, 0
end
