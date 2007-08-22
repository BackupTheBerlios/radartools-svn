;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;      mm_:   MATRIX MATHEMATICS routines                     ;;;
;;;             for fast mathematical operations                ;;;
;;;             of complex matrices/vectors/scalars             ;;;
;;;             over all dimensions                             ;;;
;;;             utilising mathematical matrix notation          ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; matrix trace over all dimensions
;;;   Maxim Neumann - 03/2006
;;;   based on rat-block-routines by A. Reigber and S. Guillaso
;;;
;;; mm_trace(a)     <==>  trace(a[*,*,0])



function mm_trace, A
  siz = size(A)
  if siz[siz[0]+2] eq 1 then return, A

  trace = A[0,0,*,*,*,*,*,*]
  for i=1,siz[1]-1 do $
     trace += A[i,i,*,*,*,*,*,*]

  return, reform(trace,/overwrite)
end
