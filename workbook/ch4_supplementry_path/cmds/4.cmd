require stream,2.7.14p
require iocStats,ae5d083

epicsEnvSet "TOP" "$(E3_CMD_TOP)/.."

system "bash $(TOP)/tools/random.bash"

iocshLoad "$(TOP)/tools/random.cmd"

epicsEnvSet("P", "IOC-$(NUM)")
epicsEnvSet("IOCNAME", "$(P)")
epicsEnvSet("PORT", "CGONPI")

epicsEnvSet("STREAM_PROTOCOL_PATH", ".:$(TOP)/db")

drvAsynIPPortConfigure("$(PORT)", "127.0.0.1:9999", 0, 0, 0)

dbLoadRecords("$(TOP)/db/gconpi-stream.db", "SYSDEV=$(IOCNAME):KAM-RAD1:,PORT=$(PORT)")
dbLoadRecords("iocAdminSoft.db","IOC=$(IOCNAME):IocStat")

iocInit()


