;------------------------------------------------------------------------
; RAT Module: get_par
;
; written by    : Maxim Neumann
; last revision : 17.Oct.2005
;------------------------------------------------------------------------
; 
;------------------------------------------------------------------------
; PARAMETERS:
;------------------------------------------------------------------------
; RETURN: status value:
;   0: everything ok, the value is provided
;   1: error: wrong entry name
;   2: error: value not set
;------------------------------------------------------------------------
; EXAMPLE:
;------------------------------------------------------------------------

function get_par, name, value
  common rit, pars             ; pars== parameters structure ==parstruct

  par_names = tag_names(pars)
  i = where(strlowcase(par_names) eq strlowcase(name),whereNr)

  value  = !VALUES.F_NAN

;;; ERROR: wrong entry name
  if whereNr lt 1 then $
     return, 1

;;; ERROR: value not set
  if pars.(i) eq ptr_new() then $
     return, 2

  value =  *pars.(i)
  return, 0
end
