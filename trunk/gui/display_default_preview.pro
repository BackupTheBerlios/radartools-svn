pro display_default_preview,xsize,ysize
	image = bytarr(xsize,ysize)
	tvlct,r_old,g_old,b_old,/get
	r = [192,bytarr(254)]
	g = [192,bytarr(254)]
	b = [192,bytarr(254)]
	tvlct,r,g,b
	tv,image
	tvlct,r_old,g_old,b_old
end
