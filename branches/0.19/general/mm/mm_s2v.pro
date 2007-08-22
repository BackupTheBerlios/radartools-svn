;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;	 mm_:	MATRIX MATHEMATICS routines			;;;
;;;		for fast mathematical operations		;;;
;;;		of complex matrices/vectors/scalars		;;;
;;;		over all dimensions				;;;
;;;		utilising mathematical matrix notation		;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; scalars to vectors over all dimensions
;;;   Maxim Neumann - 03/2006
;;;   based on rat-block-routines by A. Reigber and S. Guillaso
;;;
;;; scalar block --> vector block
;     a --> [ a a a ]  <==>  sb[x,y] == vb[*,x,y]
;;;
;;; same as mm_v2m(a,/T)


function mm_s2v, a, dim, OVERWRITE=OVERWRITE

  siz=size(a)
  if n_elements(dim) eq 0 then dim=siz[1]

  return, reform(make_array(dim,type=siz[siz[0]+1],value=1)# $
                 a[*],[dim,siz[1:siz[0]]])

end
