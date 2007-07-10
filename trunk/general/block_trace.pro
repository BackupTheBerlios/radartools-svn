;------------------------------------------------------------------------
; RAT Module: block_trace
;
; written by    : Andreas Reigber (TUB)
; last revision : 24. March 2004
;------------------------------------------------------------------------
; blockwise span calculation (for RAT arrays)
;------------------------------------------------------------------------



function block_trace,arr
	dim = (size(arr))[1]
	out = arr[0,0,*,*]
	for i=1,dim-1 do out += arr[i,i,*,*]
        out = reform(out,/overwrite)
	return, out
end

