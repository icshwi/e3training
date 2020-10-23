require stream,2.7.14p
require iocStats,ae5d083
require recsync,1.3.0
require autosave,5.9.0


epicsEnvSet("TOP","$(E3_CMD_TOP)/..")
epicsEnvSet(P, "${USER}")
epicsEnvSet(R, "E3TRNG")
epicsEnvSet("IOC",  "$(P):$(R)")


epicsEnvSet("STREAM_PROTOCOL_PATH", ".:${TOP}/db")

drvAsynIPPortConfigure("CGONPI", "127.0.0.1:9999", 0, 0, 0)

dbLoadRecords("${TOP}/db/gconpi-stream.db", "SYSDEV=$(IOC):KAM-RAD1:,PORT=CGONPI")


loadIocsh("iocStats.iocsh", "IOCNAME=$(IOC)")
loadIocsh("recsync.iocsh",  "IOCNAME=$(IOC)")
loadIocsh("autosave.iocsh", "IOCNAME=$(IOC), AS_TOP=/tmp")



iocInit

dbl > "$(TOP)/$(IOC)_PVs.list"


