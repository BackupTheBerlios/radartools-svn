function polarEStep, covarBlock, classCovar, classWeight, lookNum

covarSize = (size(covarBlock))[1]
blockRes = (size(covarBlock))[3:4]
classNum = n_elements(classWeight)

invClassCovar = block_inv(classCovar)
lnClassDet = alog(block_det(classCovar))
lnDetBlock = alog(block_det(covarBlock))
logWeight = alog(classWeight)

logEBlock = fltarr([classNum, blockRes])
for i=0,classNum-1 do begin
    logEBlock[i,*,*] = (lookNum-covarSize)*lnDetBlock - lookNum*(lnClassDet[i] + block_trace(block_mm(reform(invClassCovar[*,*,i]),covarBlock)))
end
logEBlock *= lookNum

infInd = where(finite(logEBlock) eq 0, nr)
if (nr gt 0) then logEBlock[infInd] = min(logEBlock,/nan)

return, logEBlock

end
