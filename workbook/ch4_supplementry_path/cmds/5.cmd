require stream,2.7.14p
require iocStats,ae5d083
require recsync,1.3.0
require autosave,5.9.0

epicsEnvSet "TOP" "$(E3_CMD_TOP)/.."

system "bash $(TOP)/tools/random.bash"
iocshLoad "$(TOP)/tools/random.cmd"

epicsEnvSet("P", "IOC-$(NUM)")
epicsEnvSet("IOCNAME", "$(P)")
epicsEnvSet("PORT", "CGONPI")

epicsEnvSet("STREAM_PROTOCOL_PATH", ".:$(TOP)/db")

drvAsynIPPortConfigure("$(PORT)", "127.0.0.1:9999", 0, 0, 0)

dbLoadRecords("${TOP}/db/gconpi-stream.db", "SYSDEV=$(IOCNAME):KAM-RAD1:,PORT=CGONPI")

loadIocsh("iocStats.iocsh", "IOCNAME=$(IOCNAME)")
loadIocsh("recsync.iocsh",  "IOCNAME=$(IOCNAME)")
loadIocsh("autosave.iocsh", "IOCNAME=autosave, AS_TOP=$(TOP)")

iocInit

dbl > "$(TOP)/$(IOCNAME)_PVs.list"


