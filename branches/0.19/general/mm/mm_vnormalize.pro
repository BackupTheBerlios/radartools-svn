;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;	 mm_:	MATRIX MATHEMATICS routines			;;;
;;;		for fast mathematical operations		;;;
;;;		of complex matrices/vectors/scalars		;;;
;;;		over all dimensions				;;;
;;;		utilising mathematical matrix notation		;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; vector normalization over all dimensions
;;;   Maxim Neumann - 03/2006
;;;
;;; mm_vNormalize(a)	<==>  a[*,0]/norm(a[*,0])

function mm_vNormalize, a

  return, a/mm_s2v(sqrt(total(abs(a)^2,1)),(size(a,/dim))[0])

end
