# Chapter 11: Other dependencies

[Return to Table of Contents](README.md)

On chapter 7 we presented "module header files dependency", but as we've seen this is just one of many possible dependencies. On this chapter we present some of the other possible dependencies.

## Lessons overview

In this lesson, you'll learn how to do the following:

* Use a new record type from other module on your module
* Use a db or template file from other module to generate a new db file on your module

---

## Using a new record type

Example of acalcout use, from module [calc](https://github.com/epics-modules/calc), for linear conversion of an existent waveform

### Create a new module 

Please follow the instructions on [Chapter 8](chapter8.md), we will consider the module name is `linconv` and the e3 module `e3-linconv`.

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

On this example `OFFSET` will be the offset value and `SLOPE` the slope value applied to a waveform with values 0..99. The record `LINCONV_create` is the acalcout record which calculates the resultant waveform. Then the resultant 
waveform is directed to record `LINCONV`.

More information about acalcout could be found [here](https://epics.anl.gov/bcda/synApps/calc/calc.html).

Besides the db file itself is expected that you change the `linconv.Makefile` to include the `linconv.db`.

### Change e3-linconv to uses acalcout
 
So, now with that db file, if you try to run an startup script like this:

```
require lineonv, 0.0.1
dbLoadRecords("linconv.db")
```

You will receive a message like this:

```
Record "LINCONV_create" is of unknown type "acalcout"
```

This error happens because the definition of acalcout type come from calc module. 

So, what you should do to solve this? One possible approach is include in your startup script something like this:

```
require calc, 3.7.1
```

The problem with this approach is, every time you use your linconv module you should include this. Besides that you should know what calc version to use.

A better approach will require calc module when you require linconv, and here is the main new point on this lesson. To do this you should change some files on your `e3-linconv` repository. First you should change your `configure/CONFIG_MODULE` to define what calc version you want to use, to do this you should add this line:

```
CALC_DEP_VERSION:=3.7.1
```

Then you should change the `linconv Makefile` to recover the calc version and to require it, to do this you should add these lines to `linconv.Makefile`:

```
REQUIRED=calc

ifneq ($(strip $(CALC_DEP_VERSION)),)
calc_VERSION=$(CALC_DEP_VERSION)
endif
```
Here is the key point is **`REQUIRED`**, which allows the building system to add its dependency directly to a generated `dep` file in addition to a compiler calculated dependency. 


Now you should compile and install the module:

```
make vars
make init
make build
make install
```

You can check to see if calc was included as a dependency on your linconv module, on the file `$(E3_REQUIRE_LOCATION)/siteMods/linconv/master/lib/linux-x86_64/linconv.dep` you should see this:

```
calc 3.7.1
```

### Testing linconv

Now with this configuration you can try again the same startup script:

```
require lineonv, 0.0.1
dbLoadRecords("linconv.db")
```

Congratulations! Now you should be able to read `LINCONV` pv and set `SLOPE` and `OFFSET`.

## Using an external db/template file

For this part of the training we will create a simple PID controller using the record type EPID defined on [std module](https://github.com/epics-modules/std). Besides the EPID record we will use one db file present on std module.

In our module we will do something similar to the ioc example present at std module on the files `pid_slow.template` and `st.cmd` on [iocStdTest](https://github.com/epics-modules/std/tree/master/iocBoot/iocStdTest). Our plan is to use the file `pid_control.db` [1] from the std module.

### Create a new module 

To start this you will need to create a new module, to do this follow the instructions on [Chapter 8](chapter8.md). For our setup the module name will be considered *mypid*.

### Create a substitution file

Now we will create in our module a substitution file that uses the `pid_control.db` file as a template file [1]. You should create a `pid.substitutions` file within this content:

```
file "pid_control.db"
{
    pattern
    {P,        PID,       INP,         OUT,        LOPR,  HOPR,  DRVL,  DRVH,  PREC,   KP,  KI,   KD,  SCAN}
    {mypid:,  PID1,    pidDemoInp,   pidDemoOut,   0,    100,     0,    5,     3,     0.2,  3.,   0.,  ".1 second"}
    
}

```

This file is just an example, and uses as `INP` and `OUT` in existent PVs, but for our test is enough. Note that there is no hard-code path or variable within the substitution file. 

If you change the `mypid.Makefile` and try to compile this module you should receive a message like this:

```
msi: Can't open file 'pid_control.db'
```
This is because `MSI` has no idea where `pid_control.db` file is. One should tell the building system where it is. 

### Add std as a dependency

To solve this, the first step is to set std as a dependency. As we see on previous lesson you should edit `mypid.Makefile` and `CONFIGURE_MODULE` files.

On `mypid.Makefile` you should add:
``` 
REQUIRED += std

ifneq ($(strip $(STD_DEP_VERSION)),)
std_VERSION=$(STD_DEP_VERSION)
endif

```

And add the following line into `CONFIG_MODULE`:
```
STD_DEP_VERSION:=3.5.0
```

### Add std on `USR_DBFLAGS`

To allow that your substitutions file uses db files from std you should include the std db folder on `USR_DBFLAGS`. So on `mypid.Makefile` you add this line:

```
USR_DBFLAGS += -I $(E3_SITEMODS_PATH)/std/$(std_VERSION)/db
```

This line will tell to `MSI` where find the `pid_control.db`.

### Checking if everything is ok

After these changes you can compile again your module and you shouldn't see any error. If you would like to check, you can go to your module folder and see the `pid.db` generated file, the file should be at `$(E3_REQUIRE_LOCATION)/siteMods/mypid/master/db/pid.db`


## Example files

The example files showed in this tutorial could be found at 
[e3-moduleexample](https://gitlab.esss.lu.se/epics-examples/e3-moduleexample.git)
and [moduleexample](https://gitlab.esss.lu.se/epics-examples/moduleexample.git).
Note that the module name is moduleexample, but the db and substitutions
files are the same used on tutorial.

## Reference
[1] https://github.com/epics-modules/std/blob/master/stdApp/Db/pid_control.db


---

[Next: Chapter 12 - Release rules](chapter12.md)

[Return to Table of Contents](README.md)
