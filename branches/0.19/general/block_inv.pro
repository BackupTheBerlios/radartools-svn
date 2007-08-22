;------------------------------------------------------------------------
; RAT Module: inv
;
; written by    : Stéphane Guillaso (TUB)
; last revision : 24.February.2004
;------------------------------------------------------------------------
; inversion of 2x2, 3x3 and 4x4 [T] or [C] matrix
;------------------------------------------------------------------------

FUNCTION block_inv,in

	; DIMENSION OF IN
	cc = SIZE(in)
        IF (cc[0] lt 2) THEN BEGIN 
           print, 'Error in block_inv: matrix does not have enough dimensions!'
           RETURN, -1
        END
        vdim = cc[1]
	inverse = in - in

        CASE vdim OF
           2 : BEGIN
                determinant = block_det(in) ; CALCULATE THE DETERMINANT
		inverse[0,0,*,*] =   in[1,1,*,*]/determinant
		inverse[1,0,*,*] = - in[1,0,*,*]/determinant
		inverse[0,1,*,*] = - in[0,1,*,*]/determinant
		inverse[1,1,*,*] =   in[0,0,*,*]/determinant
             END
           3 : BEGIN
                determinant = block_det(in) ; CALCULATE THE DETERMINANT
		inverse[0,0,*,*] = (in[1,1,*,*]*in[2,2,*,*] - in[2,1,*,*]*in[1,2,*,*])/determinant
		inverse[1,0,*,*] = (in[2,0,*,*]*in[1,2,*,*] - in[1,0,*,*]*in[2,2,*,*])/determinant
		inverse[2,0,*,*] = (in[1,0,*,*]*in[2,1,*,*] - in[2,0,*,*]*in[1,1,*,*])/determinant
		inverse[0,1,*,*] = (in[2,1,*,*]*in[0,2,*,*] - in[0,1,*,*]*in[2,2,*,*])/determinant
		inverse[1,1,*,*] = (in[0,0,*,*]*in[2,2,*,*] - in[2,0,*,*]*in[0,2,*,*])/determinant
		inverse[2,1,*,*] = (in[2,0,*,*]*in[0,1,*,*] - in[0,0,*,*]*in[2,1,*,*])/determinant
		inverse[0,2,*,*] = (in[0,1,*,*]*in[1,2,*,*] - in[1,1,*,*]*in[0,2,*,*])/determinant
		inverse[1,2,*,*] = (in[0,2,*,*]*in[1,0,*,*] - in[0,0,*,*]*in[1,2,*,*])/determinant
		inverse[2,2,*,*] = (in[0,0,*,*]*in[1,1,*,*] - in[1,0,*,*]*in[0,1,*,*])/determinant
             END
           ELSE : CASE cc[0] OF
              2: inverse = la_invert(in,status=ignore)
              3: BEGIN
                 FOR i=0,cc[3]-1 DO inverse[*,*,i]=la_invert(in[*,*,i], status=ignore)
              END
              4: BEGIN
                 FOR i=0,cc[3]-1 DO FOR j=0,cc[4]-1 DO inverse[*,*,i,j]=la_invert(in[*,*,i,j], status=ignore)
              END
              5: BEGIN
                 FOR i=0,cc[3]-1 DO FOR j=0,cc[4]-1 DO FOR k=0,cc[5]-1 DO inverse[*,*,i,j,k]=la_invert(in[*,*,i,j,k], status=ignore)
              END
           ENDCASE
        ENDCASE
        RETURN, inverse
END
