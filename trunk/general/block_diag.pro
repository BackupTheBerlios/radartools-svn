;------------------------------------------------------------------------
; RAT Module: block_diag
;
; written by    : Maxim Neumann (TUB)
; last revision : 06. December 2004
;------------------------------------------------------------------------
; blockwise matrix diagonal calculation (for RAT arrays)
;------------------------------------------------------------------------

function block_diag,arr, OVERWRITE=OVERWRITE

  dim = (size(arr))[1]
  if keyword_set(OVERWRITE) then begin
     for i=1,dim-1 do arr[i,0,*,*,*,*] = reform(arr[i,i,*,*,*,*])
     return, reform(arr[*,0,*,*,*,*])
  endif else begin
     out = reform(arr[*,0,*,*,*,*])
     for i=1,dim-1 do out[i,*,*,*,*] = reform(arr[i,i,*,*,*,*])
     return, out
  endelse

end
