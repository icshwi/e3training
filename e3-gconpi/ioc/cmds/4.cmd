
require stream,2.7.7
require iocStats,1856ef5

epicsEnvSet("TOP","${TOP}")
epicsEnvSet(P, "20180509")
epicsEnvSet(R, "E3TRNG")
epicsEnvSet("IOC",  "$(P):$(R)")

epicsEnvSet("STREAM_PROTOCOL_PATH", ".:${TOP}/db")
drvAsynIPPortConfigure("CGONPI", "127.0.0.1:9999", 0, 0, 0)
dbLoadRecords("${TOP}/db/gconpi-stream.db", "SYSDEV=KAM:RAD1:,PORT=CGONPI")



epicsEnvSet(P, "20180509")
epicsEnvSet(R, "E3TRNG")
epicsEnvSet("IOC",  "$(P):$(R)")
epicsEnvSet("IOCST", "$(IOC):IocStats")
dbLoadRecords("iocAdminSoft.db","IOC=${IOCST}")


iocInit


dbl > "$(TOP)/$(IOC)_PVs.list"
