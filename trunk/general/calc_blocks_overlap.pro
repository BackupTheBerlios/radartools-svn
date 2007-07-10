pro calc_blocks_overlap,ydim,bs,overlap,nrblocks,bs_last,FIX=fix

recalculate:

	if bs ge ydim then begin
		nrblocks = 1
		bs = ydim
		bs_last = ydim
		return
	endif


	nrblocks = 1
	ypos1 = 0                
	ypos2 = bs - overlap
	while (ypos2 lt ydim) do begin
		ypos1 = ypos2 - overlap
		ypos2 = ypos1 + bs - overlap
		nrblocks++
	endwhile
	bs_last = ydim - ypos1

; can I read the last big block???
	if (nrblocks-1) * (bs - 2*overlap) + 2*overlap ge ydim then begin
		overlap++
		goto,recalculate
	endif

; last block too small?
	if bs_last le overlap then begin
		overlap++
		goto,recalculate
	endif

end
