;-----------------------------------------------------------------
; rmnanq.pro
;
; written by Andreas Reigber
;------------------------------------------------------------------
; replaces all "nanq" in an array with zeros
; 
; extended to handle up to 9 arrays (mn, 24.3.5)
;------------------------------------------------------------------
; This software has been released under the terms of the GNU Public
; license. See http://www.gnu.org/copyleft/gpl.html for details.
;------------------------------------------------------------------
pro rmnanq,array,a2,a3,a4,a5,a6,a7,a8,a9,REPL=repl,NR=nr
   if n_elements(repl) eq 0 then repl=0.0

   err=where(~finite(array),test)
   if test ne 0 then array[err]=repl
   nr = test

   switch n_params() of
      9: begin
         err=where(~finite(a9),test)
         if test ne 0 then a9[err]=repl
         nr = [nr,test]
      end
      8: begin
         err=where(~finite(a8),test)
         if test ne 0 then a8[err]=repl
         nr = [nr,test]
      end
      7: begin
         err=where(~finite(a7),test)
         if test ne 0 then a7[err]=repl
         nr = [nr,test]
      end
      6: begin
         err=where(~finite(a6),test)
         if test ne 0 then a6[err]=repl
         nr = [nr,test]
      end
      5: begin
         err=where(~finite(a5),test)
         if test ne 0 then a5[err]=repl
         nr = [nr,test]
      end
      4: begin
         err=where(~finite(a4),test)
         if test ne 0 then a4[err]=repl
         nr = [nr,test]
      end
      3: begin
         err=where(~finite(a3),test)
         if test ne 0 then a3[err]=repl
         nr = [nr,test]
      end
      2: begin
         err=where(~finite(a2),test)
         if test ne 0 then a2[err]=repl
         nr = [nr,test]
      end
   endswitch
end
