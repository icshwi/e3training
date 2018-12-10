require iocStats,ae5d083
#require recsync, 1.3.0

epicsEnvSet "EXECUTE_TOP"     $(E3_IOCSH_TOP)
epicsEnvSet "STARTUP_TOP"     $(E3_CMD_TOP)
epicsEnvSet "TOP"             $(E3_CMD_TOP)/..

epicsEnvSet "IOCSTATS_MODULE_PATH"          $(iocStats_DIR)
epicsEnvSet "IOCSTATS_MODULE_VERSION"       $(iocStats_VERSION)
epicsEnvSet "IOCSTATS_MODULE_DB_PATH"       $(iocStats_DB)
epicsEnvSet "IOCSTATS_MODULE_TEMPLATE_PATH" $(iocStats_TEMPLATES)



iocInit
