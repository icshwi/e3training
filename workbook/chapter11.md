# Chapter 11: Other dependencies
 

On chapter 7 we presented "module header files dependency", but as we've 
seen this is just one of many possible dependencies. On this chapter we
present some of the other possible dependencies.

## Lessons overview

In this lesson, you'll learn how to do the following:
* Use a new record type from other module on your module
* Use a db or template file from other module to generate a new db file on your module

## Using a new record type

Example of acalcout use, from module [calc](https://github.com/epics-modules/calc), for linear conversion of an existent waveform

### Create a new module 

Follow the instructions on [Chapter 8](chapter8.md), we will consider the 
module name is linconv and the e3 wrapper e3-linconv.

### Create the database file with linear conversion

The db file should be like this

```
record(ao, "OFFSET") {
    field(VAL,"0.5")
    field(PINI,"YES")
    field(FLNK, "LINCONV_create")
}

record(ao, "SLOPE") {
    field(VAL,"3")
    field(PINI,"YES")
    field(FLNK, "LINCONV_create")
}

record(acalcout, "LINCONV_create") {
    field(INPA, "OFFSET")
    field(INPB, "SLOPE")
    field(NELM, "100")
    field(CALC, "(IX*B)+A")
    field(OUT, "LINCONV PP")
}

record(waveform, "LINCONV"){
    field(FTVL, "FLOAT")
    field(NELM, "100")
}
```

On this example OFFSET will be the offset value and SLOPE the slope
value applied to a waveform with values 0..99. The record LINCONV_create is the 
acalcout record which calculates the resultant waveform. Then the resultant 
waveform is directed to record LINCONV.

More information about acalcout could be found [here](https://epics.anl.gov/bcda/synApps/calc/calc.html)

### Change e3-linconv to uses acalcout
 
So, now with your great db file, if you try to run an startup script like this:

```
require lineonv, 0.0.1
dbLoadRecords("linconv.db")
```

You will receive a message like this:

```
Record "LINCONV_create" is of unknown type "acalcout"
```

This error happens because the definition of acalcout type come from calc 
module. 

So, what you should do to solve this? One possible approach is include 
in your startup script something like this:

```
require calc, 3.7.1
```

The problem with this approach is, every time you use your linconv module
you should include this. Besides that you should know what calc version to use.

A better approach will require calc module when you require linconv, and here
is the main new point on this lesson. To do this you should change some files 
on your e3-linconv repository. First you should change your 
configure/CONFIG_MODULE to define what calc version you want to use, to do 
this you should add this line:

```
CALC_DEP_VERSION:=3.7.1
```

Then you should change the linconv Makefile to recover the calc version and 
to require it, to do this you should add these lines to linconv.Makefile:

```
REQUIRED=calc

ifneq ($(strip $(CALC_DEP_VERSION)),)
calc_VERSION=$(CALC_DEP_VERSION)
endif
```

## Using an external db/template file

For this part of the training we will create a simple PID controller using
the record type EPID defined on [std module](https://github.com/epics-modules/std).

To start this you will need to creat a new module, to do this follow the 
instructions on [Chapter 8](chapter8.md). For our setup will be considered
the module name is *mypid*.

In our module we will do something similar to the ioc example present at
std module on the files pid_slow.template and st.cmd on [iocStdTest](https://github.com/epics-modules/std/tree/master/iocBoot/iocStdTest) .

