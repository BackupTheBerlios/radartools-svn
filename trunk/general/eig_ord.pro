;+
; NAME:
;	EIG_ORD
;
; PURPOSE:
;	This function calculate and order eigenvalue/vectors of a hermitian matrix
;  Rxx
;
; CATEGORY:
;	Mathematics.
;
; CALLING SEQUENCE:
;	EIG_ORD, Rxx, sens, V, D
;
; INPUTS:
;	Rxx:	a hermitian matrix.
;	sens: 1 to an increasing order, -1 to a decreasing order
;
; OUTPUTS:
;	V:	eigenvector matrix.
;	D: eigenvalue vector
;
; MODIFICATION HISTORY:
; 	Written by:	Stephane Guillaso.
;-
PRO eig_ord,Rxx,sens,V,D

; Calcul des valeurs/vecteurs propres
 D = la_eigenql(Rxx,eigenvectors=V)

V = transpose(V)
; Inverse l'ordre des valeurs/vecteurs propres si demande'e
if sens eq -1 then begin
  D = reverse(D)
  V = reverse(V)
endif

; Enleve la phase des premiers termes des vecteurs propres
xdim = (size(V))[1]
for ii=0,xdim-1 do begin
  phi = atan(V(ii,0),/phase)
  V(ii,*) = V(ii,*) * exp(complex(0,-phi))
endfor
	
END
