
require stream,2.7.7

epicsEnvSet("TOP","${TOP}")

epicsEnvSet("STREAM_PROTOCOL_PATH", ".:${TOP}/db")

drvAsynIPPortConfigure("CGONPI", "127.0.0.1:9999", 0, 0, 0)

dbLoadRecords("${TOP}/db/gconpi-stream.db", "SYSDEV=KAM:RAD1:,PORT=CGONPI")


iocInit


