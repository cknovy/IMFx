'close @all
'Create a workfile on a monthly frequency
'wfcreate struct m 2006m1 2015m12

if @pageexist("StructBreak_M") then
	pagedelete StructBreak_M
endif
 
pagecreate(page="StructBreak_M") m 2006m1 2015m12

smpl @all
genr Dl=3*@after("2009m2")

'Creat a variable pi=5 then replace using the a random generator starting from t+1
series p = 5 
smpl @first+1 @last
'fix the seed for the random number generator so the same serieas are generated every time
rndseed 1

series p = 5+.5*p(-1)+1*nrnd-Dl

graph gr1.line p 
show gr1

smpl @first+1 2014m12
'Estimate linear trend
equation eq1.ls p c @trend
eq1.fit p_hat_lin

graph gr2.line p p_hat_lin
gr2.setelem(2) legend("Linear trend")
show gr2

'Estimate misspecified AR(1)
equation eq2.ls p c p(-1)

'Estimate true DGP
equation eqtrue.ls p c p(-1) dl


