;------------------------------------------------------------------------
; RAT Module: block_transpose
;
; written by    : Maxim Neumann (TUB)
; last revision : 06. December 2004
;------------------------------------------------------------------------
; blockwise matrix transpose (for RAT arrays)
; only for 3- and 4- dimensional arrays!
;------------------------------------------------------------------------

function block_transpose,arr, OVERWRITE=OVERWRITE

  siz = size(arr)
  if siz[0] eq 3 then arr = reform(arr,[1,siz[1:3]],/OV)
  if keyword_set(OVERWRITE) then begin
     arr = transpose(arr,[1,0,2,3])
     return, arr
  endif else begin
     out = transpose(arr,[1,0,2,3])
     if siz[0] eq 3 then arr = reform(arr,siz[1:3],/OV)
     return, out
  endelse

end
