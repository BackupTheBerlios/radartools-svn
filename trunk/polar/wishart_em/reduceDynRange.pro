pro reduceDynRange, covarBlock

covarSize = (size(covarBlock))[1]
covarOffset = covarSize^2
blockRes = (size(covarBlock))[3:4]

normBlock = abs(block_trace(covarBlock))
normBlock = alog(1.0+normBlock)/normBlock

dataInd = covarOffset*lindgen(blockRes)
for i=0,covarOffset-1 do begin
    covarBlock[i+dataInd] = normBlock*covarBlock[i+dataInd]
end

end

