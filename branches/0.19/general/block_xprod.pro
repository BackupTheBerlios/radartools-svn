;------------------------------------------------------------------------
; RAT Module: block_xprod
;
; written by    : Andreas Reigber (TUB)
; last revision : 24.February.2004
;------------------------------------------------------------------------
; blockwise outer product of vectors
;------------------------------------------------------------------------

function block_xprod,arr1,arr2
	common rat, types, file, wid, config
        siz  = size(arr1)
	dim  = siz[1]
        xdim = siz[2]
	ydim = siz[3]
        type = siz[4]

	out = make_array([dim,dim,xdim,ydim],type=type)
	for i=0,dim-1 do for j=0,dim-1 do out[i,j,*,*] = arr1[j,*,*] * arr2[i,*,*]
	return,out

end
