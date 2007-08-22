FUNCTION block_mm,in1,in2
	
	; DIMENSION OF IN1 and IN2
	cc1   = SIZE(in1) & cc2   = SIZE(in2)
	vdim1 = cc1[1]    & vdim2 = cc2[1]
	zdim1 = cc1[2]    & zdim2 = cc2[2]

	IF vdim1 NE zdim2 THEN BEGIN
		PRINT,'oups, error'
		RETURN,0
	ENDIF
	
	case 1 of
	
	cc1[0] GT cc2[0]: BEGIN
		IF cc1[0] EQ 2 THEN BEGIN
			out = MAKE_ARRAY(vdim2,zdim1)
			FOR vv = 0,vdim2-1 DO $
				FOR zz=0,zdim1-1 DO $
					FOR kk=0,vdim1-1 DO $
						out[vv,zz] += in1[kk,zz] * in2[vv,kk]
		ENDIF
		IF cc1[0] EQ 3 THEN BEGIN
			out = MAKE_ARRAY(vdim2,zdim1,cc1[3])
			FOR vv = 0,vdim2-1 DO $
				FOR zz=0,zdim1-1 DO $
					FOR kk=0,vdim1-1 DO $
						out[vv,zz,*] += in1[kk,zz,*] * in2[vv,kk]
		ENDIF
		IF cc1[0] EQ 4 THEN BEGIN
			out = MAKE_ARRAY(vdim2,zdim1,cc1[3],cc1[4])
			FOR vv = 0,vdim2-1 DO $
				FOR zz=0,zdim1-1 DO $
					FOR kk=0,vdim1-1 DO $
						out[vv,zz,*,*] += in1[kk,zz,*,*] * in2[vv,kk]
		ENDIF
	END
	
	cc1[0] LT cc2[0]: BEGIN
		if cc2[0] EQ 2 then BEGIN
			out = MAKE_ARRAY(vdim2,zdim1)
			FOR vv = 0,vdim2-1 DO $
				FOR zz=0,zdim1-1 DO $
					FOR kk=0,vdim1-1 DO $
						out[vv,zz] += in1[kk,zz] * in2[vv,kk]
		ENDIF
		IF cc2[0] EQ 3 THEN BEGIN
			out = MAKE_ARRAY(vdim2,zdim1,cc2[3])
			FOR vv = 0,vdim2-1 DO $
				FOR zz=0,zdim1-1 DO $
					FOR kk=0,vdim1-1 DO $
						out[vv,zz,*] += in1[kk,zz] * in2[vv,kk,*]
		ENDIF
		IF cc2[0] EQ 4 THEN BEGIN
			out = MAKE_ARRAY(vdim2,zdim1,cc2[3],cc2[4])
			FOR vv = 0,vdim2-1 DO $
				FOR zz=0,zdim1-1 DO $
					FOR kk=0,vdim1-1 DO $
						out[vv,zz,*,*] += in1[kk,zz] * in2[vv,kk,*,*]
		ENDIF
	END
	
	else: begin
		if cc2[0] EQ 2 then BEGIN
			out = MAKE_ARRAY(vdim2,zdim1)
			FOR vv = 0,vdim2-1 DO $
				FOR zz=0,zdim1-1 DO $
					FOR kk=0,vdim1-1 DO $
						out[vv,zz] += in1[kk,zz] * in2[vv,kk]
		ENDIF
		IF cc2[0] EQ 3 THEN BEGIN
			out = MAKE_ARRAY(vdim2,zdim1,cc2[3])
			FOR vv = 0,vdim2-1 DO $
				FOR zz=0,zdim1-1 DO $
					FOR kk=0,vdim1-1 DO $
						out[vv,zz,*] += in1[kk,zz,*] * in2[vv,kk,*]
		ENDIF
		IF cc2[0] EQ 4 THEN BEGIN
			out = MAKE_ARRAY(vdim2,zdim1,cc2[3],cc2[4])
			FOR vv = 0,vdim2-1 DO $
				FOR zz=0,zdim1-1 DO $
					FOR kk=0,vdim1-1 DO $
						out[vv,zz,*,*] += in1[kk,zz,*,*] * in2[vv,kk,*,*]
		ENDIF
	end
	endcase
	
	
	RETURN,out
	
END
