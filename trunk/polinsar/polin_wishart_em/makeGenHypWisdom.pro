function makeGenHypWisdom, lookNum, a, b, logMinTerm
; Compute the number of terms we need to sum in the generalised
; hypergeometric function. This only works because 0<=x<=1!

maxWisdom = long(50000)
wisdom = long(1)

lnTerm = 0.0
lnFact = 0.0
lnX = alog(0.95)
while((real_part(lnTerm) gt logMinTerm) and (wisdom lt maxWisdom)) do begin
    lnFact += alog(wisdom)
    lnTerm = total(lngamma(a+wisdom)-lngamma(a)) + wisdom*lnX
    lnTerm -= total(lngamma(b+wisdom)-lngamma(b)) + lnFact
    wisdom += 1l
end

return, wisdom
end
