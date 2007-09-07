;------------------------------------------------------------------------
; RAT - Radar Tools
;------------------------------------------------------------------------
; RAT Module: digamma
;------------------------------------------------------------------------
; The contents of this file are subject to the Mozilla Public License
; Version 1.1 (the "License"); you may not use this file except in
; compliance with the License. You may obtain a copy of the License at
; http://www.mozilla.org/MPL/
;
; Software distributed under the License is distributed on an "AS IS"
; basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
; License for the specific language governing rights and limitations
; under the License.
;
; The Initial Developer of the Original Code is the RAT development team.
; All Rights Reserved.
;------------------------------------------------------------------------
function digamma, z
;Psi     Psi (or Digamma) function valid in the entire complex plane.
;
;                 d
;        Psi(z) = --log(Gamma(z))
;                 dz
;
;usage: [f] = psi(z)
;
;
;        Z may be complex and of any size.
;
;        This program uses the analytical derivative of the
;        Log of an excellent Lanczos series approximation
;        for the Gamma function.
;        
;References: C. Lanczos, SIAM JNA  1, 1964. pp. 86-96
;            Y. Luke, "The Special ... approximations", 1969 pp. 29-31
;            Y. Luke, "Algorithms ... functions", 1977
;            J. Spouge,  SIAM JNA 31, 1994. pp. 931
;            W. Press,  "Numerical Recipes"
;            S. Chang, "Computation of special functions", 1996
;
;

;Paul Godfrey
;pgodfrey@intersil.com
;July 13, 2001
;see gamma for calculation details...

siz = size(z)
if (siz[0] gt 0) then siz = siz[1:siz[0]] else siz=1
zz=z

f = 0.0*z ; reserve space in advance

;reflection point
p=where(float(z) lt 0.5, nr)
if (nr gt 0) then z[p]=1-z[p]

;Lanczos approximation for the complex plane
 
g=607.0/128.0 ; best results when 4<=g<=5
 
c = [  0.99999999999999709182, $
      57.156235665862923517, $
     -59.597960355475491248, $
      14.136097974741747174, $
      -0.49191381609762019978, $
        .33994649984811888699e-4, $
        .46523628927048575665e-4, $
       -.98374475304879564677e-4, $
        .15808870322491248884e-3, $
       -.21026444172410488319e-3, $
        .21743961811521264320e-3, $
       -.16431810653676389022e-3, $
        .84418223983852743293e-4, $
       -.26190838401581408670e-4, $
        .36899182659531622704e-5]


n=0
d=0
for k=n_elements(c)-1,1,-1 do begin
    dz=1.0/(z+k-1)
    dd=c[k]*dz
    d=d+dd
    n=n-dd*dz
end
d=d+c[0]
gg=z+g-0.5;
;log is accurate to about 13 digits...

f = alog(gg) + (n/d - g/gg)

if (nr gt 0) then f[p] -= !pi/tan(!pi*zz[p])

p=where(round(zz) eq zz and float(zz) le 0.0 and imaginary(zz) eq 0.0, nr)
if (nr gt 0) then f[p] = !values.f_infinity

f=reform(f,siz);

return, f

end
