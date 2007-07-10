function center_box,drawsize,drawysize=drawysize
	common rat, types, file, wid, config

	geom = Widget_Info(wid.base, /geometry)
	posx = geom.xoffset + geom.xsize/2.0 - drawsize/2.0
	posy = geom.yoffset + geom.ysize/2.0 - 30
	IF KEYWORD_SET(drawysize) THEN posy = geom.yoffset + geom.ysize/2.0 - drawysize/2.0

	return,[posx,posy]
end
