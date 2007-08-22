pro finaliseEstimate, estimBlock, newEstimBlock, energyDensity, lastDensity, temperature, randSeed

covarSize = (size(estimBlock))[1]
covarOffset = covarSize^2
blockRes = (size(energyDensity))[1:2]

energyGradient = energyDensity-lastDensity
metropolisThresh = exp(-energyGradient/temperature)
infInd = where(finite(energyDensity) eq 0, nr)
if (nr gt 0) then metropolisThresh[infInd] = 2.0

acceptInd = where(randomu(randSeed,blockRes[0],blockRes[1]) lt metropolisThresh, nr)
if (nr le 0) then return
print, '% accepted:'
print, 100.0*nr/product(blockRes[0:1])

lastDensity[acceptInd] = energyDensity[acceptInd]
energyDensity = lastDensity

acceptInd = covarOffset*(long(acceptInd))
for i=0,covarOffset-1 do begin
    estimBlock[i+acceptInd] = newEstimBlock[i+acceptInd]
end

end
