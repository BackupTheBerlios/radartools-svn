;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;	 mm_:	MATRIX MATHEMATICS routines			;;;
;;;		for fast mathematical operations		;;;
;;;		of complex matrices/vectors/scalars		;;;
;;;		over all dimensions				;;;
;;;		utilising mathematical matrix notation		;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; vectors to matrices over all dimensions
;;;   Maxim Neumann - 03/2006
;;;   based on rat-block-routines by A. Reigber and S. Guillaso
;;;
;;; vector block --> matrix block
;                 [ a b c ]
;     [a b c] --> [ a b c ]  <==>  vb[i] eq mb[i,*]
;                 [ a b c ]
;; kind of replication of origin vectors
;; generates new vectors which are similar to the origin vector
;
;                 [ a a a ]
; /T: [a b c] --> [ b b b ]  <==>  vb[i] eq mb[*,i]
;                 [ c c c ]
;; same as mm_s2v!
;; generates for every entry of every vector a new vector with same values
;; NOTE: mm_v2m(a) <==> vb_2mb(a,/T!!!)


function mm_v2m, a, dim, TRANSPOSE_MATRIX=TRANSPOSE_MATRIX

  siz = size(a)
  if n_elements(dim) eq 0 then dim=siz[1]

  if keyword_set(TRANSPOSE_MATRIX) then $
     return, reform(make_array(dim,type=siz[siz[0]+1],value=1)# $
                    a[*],[dim,siz[1:siz[0]]]) $
  else begin
     dims = indgen(siz[0]+1)
     dims[0]=1 & dims[1]=0
     return, transpose(reform(make_array(dim,type=siz[siz[0]+1],value=1)# $
                              a[*],[dim,siz[1:siz[0]]]),dims)
  endelse
end
