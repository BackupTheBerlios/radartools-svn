function ESPRIT,Rzz,M,K

	; Décomposition de Rzz
	eig_ord,Rzz,-1,VecP,ValP

	; Calcul de Es
	Es = VecP(0:K-1,*)
	
	; Calcul de ExEy
	ExEy = [Es(*,0:M-1),Es(*,M:2*M-1)]
	ExyExy = transpose(conj(ExEy)) ## ExEy

	;- CALCUL DES VALEURS/VECTEURS PROPRES
	eig_ord,ExyExy,-1,E,D

	;- GENERATION DE E
	;      --      --
	;     | E11  E12 |
	; E = |          |
	;     | E21  E22 |
	;      --      --
	E12 = E(K:2*K-1,0:K-1)
	E22 = E(K:2*K-1,K:2*K-1)

	if K ne 1 then begin
		psi = - E12 ## la_invert(E22)
		;- EXTRACTION DE LA PHASE INTERFEROMETRIQUE PAR LA METHODE ESPRIT
		phi = conj(la_eigenproblem(psi))
	endif else begin
		phi = -E12 / E22
	endelse

	;- RETOURNE LA VALEUR DE LA PHASE INTERFEROMETRIQUE
	return,phi
end
