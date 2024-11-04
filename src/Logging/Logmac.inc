ROUTINE Logging.Logmac [Type=INC]
///Define Metrics takes WorkStream Name and StepName as Arguments and creates necessary arguments for logging
#Define SetLogAttributes(%WS) Set tArr("APP_NAME") = "IRIS", tArr("CIS_SESSION_ID")=..%SessionId, tArr("CLASS_NAME")=$ClassName(),tArr("JOB_NAME")=..%ConfigName,tArr("METHOD_NAME")=##Expression($$$quote(%methodname)), tArr("CIS_IRIS_NSP") = $NAMESPACE, tArr("WORKSTREAM")=%WS
///Log Metrics takes Arguments defined and sends to stdout log using LogUtil
#Define PushLogAttributes(%Step,%tArr) Set tArr("STEP_NAME")=%Step,tSC = ##class(Logging.Util).LogStdout(%tArr)