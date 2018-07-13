# https://github.com/mdavidsaver/epics-doc
require pva2pva,1.0.0

dbLoadRecords("sum.db","INST=calc")
iocInit
