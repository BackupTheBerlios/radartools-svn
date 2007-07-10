; calculates log(pFq(a1,...,ap; b1,...,bq; x))

function lnGenHyp, a, b, x, wisdom

lngammaA = total(complex(lngamma(a)))
lngammaB = total(complex(lngamma(b)))
lnX = complex(alog(x))

for i=0,wisdom-1 do begin
    termNum = wisdom-i-1

    lnFact = lngamma(termNum+1)

    term = termNum*lnX
    term += total(lngamma(a+termNum))-lngammaA
    term -= lnFact + total(lngamma(b+termNum))-lngammaB

    if (i ne 0) then begin
        logShift = real_part(lnSeriesTotal)>real_part(term)
        lnSeriesTotal = alog(exp(lnSeriesTotal-logShift)+exp(term-logShift))+logShift
    end else begin
        lnSeriesTotal = term
    end
end

return, lnSeriesTotal
end
