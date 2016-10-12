smpl @all

'name of the variable
%v="ygr"

' Rolling or expanding strategy? 
'If !strategy_rolling=1 rolling strategy is used,
'if !strategy_rolling=0 expanding strategy is used
!strategy_rolling=1
' length of  out-of-sample forecast 
!n_step_forecast = 2

' number of rolling samples
!num_rolling = 21

' last date in the first estimation period (this is T in the slides)
%T="2008q4"



'length of the rolling forecast window (denoted as w in the lectures). 
'NOTE: This parameter is ignored if expanding strategy is used
!w=24

'================= Main Program ========================
'Initialization of forecast evaluation statistics
matrix(1,!n_step_forecast) BIAS=0
matrix(1,!n_step_forecast) MSE=0
matrix(1,!n_step_forecast) RMSE=0
matrix(1,!n_step_forecast)  MAE=0
matrix(1,!n_step_forecast)  MAPE=0

'for each rolling sample calculate forecast errors and evaluation statistics for each horizon
for !i=0 to !num_rolling-1
	%end_data_smpl=%T+"+!i"

	if abs(!strategy_rolling-1)<0.001 then
		%begin_data_smpl=%T+"-!w+1+!i"
		'sample for estimation
		smpl {%begin_data_smpl} {%end_data_smpl}
	else
		'sample for estimation
		smpl @first {%end_data_smpl}
	endif

	'====== Run your forecast model here ============================ 
	'It can be as complicated as you want. 
	'%v is the variable that will be forecasted (see the beginnning of the file)
	equation eq1.ls {%v} c {%v}(-1)
  	'==========================================================
	' forecast inflation for !n_step_forecast ahead
	'forecast sample 
	delete(noerr) fsmpl
	sample fsmpl {%end_data_smpl}+1 {%end_data_smpl}+!n_step_forecast 
	smpl fsmpl
	
	'if forecasting different variable change the variable name
	eq1.forecast(g) {%v}_f  {%v}_f_se
	
	'record forecast error for all horizons
	series {%v}_e_ser={%v}-{%v}_f
	
	'convert p and p_e from series to vectors
	vector {%v}_e 
	stom({%v}_e_ser,{%v}_e,fsmpl)
	stom({%v},{%v}_vec, fsmpl)

	for !j=1 to !n_step_forecast
		'string forecast_date=@datestr(@dateadd(@dateval(%firstdate),!i+!n_step_forecast,"MM"), "yyyy:mm")
		'smpl  {forecast_date} {forecast_date}
		
	'update all forecast statistics for horizon j
	BIAS(1,!j)=BIAS(1,!j)+({%v}_e(!j)) / (!num_rolling)
	MSE(1,!j)=MSE(1,!j)+(( {%v}_e(!j) )^2) / (!num_rolling)
	MAE(1,!j)=MAE(1,!j)+( @abs({%v}_e(!j)) ) / (!num_rolling)
	MAPE(1,!j)=MAPE(1,!j)+(@abs({%v}_e(!j)/{%v}_vec(!j))) / (!num_rolling)
	next

next


RMSE=@sqrt(MSE)
matrix SE=@sqrt(MSE-@epow(BIAS,2))

'put all of the statistics in a nice table
delete(noerr) results
table(6,!n_step_forecast) results
results(1,1)="HORIZON"
results (2,1)="Bias"		
results (3,1)="MSE"		
results (4,1)="RMSE"	
results (5,1)="SE"
results (6,1)="MAE"
results (7,1)="MAPE"

for !j=1 to !n_step_forecast
	results(1,!j+1)="h="+@str(!j)
	results(2,!j+1)=@str(BIAS(1,!j),"f2.3")  
	results(3,!j+1)=@str(MSE(1,!j),"f2.3")
	results(4,!j+1)=@str(RMSE(1,!j),"f2.3")
	results(5,!j+1)=@str(SE(1,!j),"f2.3")
	results(6,!j+1)=@str(MAE(1,!j),"f2.3")
	results(7,!j+1)=@str(MAPE(1,!j),"f2.3")
next

show results


