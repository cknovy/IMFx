'3.45 - 3.48
pageselect PE_ratios 
PE_AUS.sheet
smpl 2000M4 2015M2
pe_aus.uroot(adf,exog=trend,lagmethod=aic) 
pe_aus.uroot(adf,exog=none,lagmethod=aic) 
pe_aus.uroot(adf, lagmethod=aic)


pe_aus.uroot(pp,exog=trend,lagmethod=aic) 
pe_aus.uroot(pp,exog=none,lagmethod=aic) 
pe_aus.uroot(pp, lagmethod=aic)

pe_aus.uroot(kpss,exog=trend,lagmethod=aic) 

pe_aus.uroot(kpss, lagmethod=aic)

smpl 2000M4 2009M5
pe_aus.uroot(adf,exog=trend,lagmethod=aic) 
pe_aus.uroot(adf,exog=none,lagmethod=aic) 
pe_aus.uroot(adf, lagmethod=aic)


pe_aus.uroot(pp,exog=trend,lagmethod=aic) 
pe_aus.uroot(pp,exog=none,lagmethod=aic) 
pe_aus.uroot(pp, lagmethod=aic)

pe_aus.uroot(kpss,exog=trend,lagmethod=aic) 

pe_aus.uroot(kpss, lagmethod=aic)

'3.49 - 3.55 Breakpoint unit root
smpl 2000M4 2015M2
pe_aus.buroot(type=ao, exog=trend, lagmethod=aic)
pe_aus.buroot(type=ao, exog=trend, break=both, lagmethod=aic)
