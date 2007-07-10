;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;	 mm_:	MATRIX MATHEMATICS routines			;;;
;;;		for fast mathematical operations		;;;
;;;		of complex matrices/vectors/scalars		;;;
;;;		over all dimensions				;;;
;;;		utilising mathematical matrix notation		;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; matrix transpose over all dimensions
;;;   Maxim Neumann - 03/2006
;;;   based on rat-block-routines by A. Reigber and S. Guillaso
;;;
;;; mm_transpose(a)	<==>  transpose(a[*,*,0])


function mm_transpose, A

  n_dim   = size(A,/N_DIM)
  case n_dim of
     0: return, A
     1: return, A
     2: return, transpose(A)
     else: begin
        dims    = indgen(n_dim)
        dims[0] = 1
        dims[1] = 0
        return, transpose(A,dims)
     endelse
  endcase

end
