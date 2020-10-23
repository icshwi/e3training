
require stream,2.7.14p
require iocStats,ae5d083

epicsEnvSet("TOP","$(E3_CMD_TOP)/..")
epicsEnvSet(P, "${USER}")
epicsEnvSet(R, "E3TRNG")
epicsEnvSet("IOC",  "$(P):$(R)")


epicsEnvSet("STREAM_PROTOCOL_PATH", ".:${TOP}/db")

drvAsynIPPortConfigure("CGONPI", "127.0.0.1:9999", 0, 0, 0)

dbLoadRecords("${TOP}/db/gconpi-stream.db", "SYSDEV=$(IOC):KAM-RAD1:,PORT=CGONPI")
dbLoadRecords("iocAdminSoft.db","IOC=$(IOC):IocStat")

iocInit

dbl > "$(TOP)/$(IOC)_PVs.list"
