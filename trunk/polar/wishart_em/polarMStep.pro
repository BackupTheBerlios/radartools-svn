pro polarMStep, covarBlock, eBlock, newCovar, newWeight, convergenceShock

covarSize = (size(covarBlock))[1]
covarOffset = covarSize^2
blockRes = (size(covarBlock))[3:4]
classNum = (size(eBlock))[1]

eNorm = max(eBlock,dimension=1,/nan)
for i=0,classNum-1 do begin
    eBlock[i,*,*] = exp(eBlock[i,*,*] - eNorm)
end

eNorm = 1.0/total(eBlock,1)
for i=0,classNum-1 do begin
    eBlock[i,*,*] *= eNorm
end
eBlock = eBlock^convergenceShock

dataInd = covarOffset*lindgen(blockRes)
for i=0,classNum-1 do begin
    for j=0,covarOffset-1 do begin
        newCovar[j+covarOffset*i] += total(eBlock[i,*,*] * covarBlock[j+dataInd])
    end
    newWeight[i] += total(eBlock[i,*,*])
end

end
