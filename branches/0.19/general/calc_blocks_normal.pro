pro calc_blocks_normal,ydim,bs,nrblocks,bs_last
	nrblocks = 1
	ypos = bs
	while (ypos lt ydim) do begin
	  ypos = ypos + bs
	  nrblocks = nrblocks + 1
	endwhile
	bs_last = ydim - (nrblocks-1) * bs
end
