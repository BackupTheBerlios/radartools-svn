;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;	 mm_:	MATRIX MATHEMATICS routines			;;;
;;;		for fast mathematical operations		;;;
;;;		of complex matrices/vectors/scalars		;;;
;;;		over all dimensions				;;;
;;;		utilising mathematical matrix notation		;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; make Hermian matrices over all dimensions
;;;   Maxim Neumann - 03/2006
;;;
;;; mm_herm(a[*,*,0])	<==>  conj(transpose(a[*,*,0]))


function mm_herm,a

  n_dim   = size(a,/N_DIM)
  case n_dim of
     0: return, conj(a)
     1: return, conj(transpose(a))
     2: return, conj(transpose(a))
     else: begin
        dims    = indgen(n_dim)
        dims[0] = 1
        dims[1] = 0
        return, conj(transpose(a,dims))
     endelse
  endcase

end
