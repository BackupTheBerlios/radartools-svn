; Modified      : mn, 08/2006

function extract_mtnames,multifile,ANZ=anz
  openr, ddd, multifile, /GET_LUN, /XDR
  dummy = 0l
  anz   = 0l
  info  = bytarr(80)
  dim   = 0l
  readu,ddd,dim
  for i=1,dim+4 do readu,ddd,dummy
  readu,ddd,anz
  readu,ddd,info

  files = strarr(anz)
  ifile = ""
  for i=1,anz do begin
     readu,ddd,ifile
     files[i-1] = ifile
  endfor
  free_lun,ddd
  if product(file_test(files)) eq 0 then $ ;; most probably relative names
     for i=0,anz-1 do $
        files[i] = filepath(ROOT=file_dirname(multifile),files[i])
  return,files
end
