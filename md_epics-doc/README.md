MD's epics-doc example
===

This folder contains the Michael's example at https://github.com/mdavidsaver/epics-doc

## Notice

I think it is very simple, and powerful example when we start it with E3. I modified commands in order to use E3 instead of the generic EPICS environment. In this example, we can start an IOC quietly quickly. Enjoy it!


## sum.db
```
iocsh.bash sum.db "INST=calc"
```

## sum.cmd
```
iocsh.bash sum.cmd
```

## sum-alarm.db
```
iocsh.bash sum-alarm.db "INST=calc"
```

## PV Access from a Shell

```
md_epics-doc (master)$ caget calc:a calc:b calc:sum
calc:a                         0
calc:b                         0
calc:sum                       0

md_epics-doc (master)$  caput calc:a 2
Old : calc:a                         0
New : calc:a                         2

 md_epics-doc (master)$ caget calc:a calc:b calc:sum
calc:a                         2
calc:b                         0
calc:sum                       2

 md_epics-doc (master)$ caput calc:b 3
Old : calc:b                         0
New : calc:b                         3


md_epics-doc (master)$ caget calc:a calc:b calc:sum
calc:a                         2
calc:b                         3
calc:sum                       5
```
