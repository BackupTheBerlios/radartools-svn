;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;	 mm_:	MATRIX MATHEMATICS routines			;;;
;;;		for fast mathematical operations		;;;
;;;		of complex matrices/vectors/scalars		;;;
;;;		over all dimensions				;;;
;;;		utilising mathematical matrix notation		;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; matrix diagonalization over all dimensions
;;;   Maxim Neumann - 03/2006
;;;   based on rat-block-routines by A. Reigber and S. Guillaso
;;;
;;; mm_diag(a[*,*,0])	<==> diag_matrix(a[*,*,0])
;;; with the assumtion that the first two dimensions are equal
;;; it is not intended to construct diagonal matrices from vectors

function mm_diag,a, OVERWRITE=OVERWRITE

  siz = size(a)
  dim = min(siz[1:2])
  newsiz = siz[0] lt 3? dim : [dim,siz[3:siz[0]]]
  if keyword_set(OVERWRITE) then begin
     for i=1,dim-1 do a[i,0,*,*,*,*,*,*] = a[i,i,*,*,*,*,*,*]
     return, reform(a[*,0,*,*,*,*,*,*],newsiz,/overwrite)
  endif else begin
     out = reform(a[*,0,*,*,*,*,*,*])
     for i=1,dim-1 do out[i,*,*,*,*,*,*] = a[i,i,*,*,*,*,*,*]
     return, reform(out,newsiz)
  endelse

end
