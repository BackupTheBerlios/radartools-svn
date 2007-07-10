function atanc,_arr
	s = size(_arr)
	type = s[s[0]+1]
	if type eq 6 or type eq 9 then $
		if float(strmid(!version.release,0,3)) lt 5.6 then $
			return,atan(imaginary(_arr),real_part(_arr)) $
			else return,atan(_arr,/phase) 
	return,atan(_arr) 
end
