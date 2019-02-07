# Appendix C : GCC 7 within CentOS7 : devtoolset-7



## Setup development tool

```
$ yum install centos-release-scl
$ yum-config-manager --enable rhel-server-rhscl-7-rpms
```

* gcc7

```
$ yum install devtoolset-7
```

## Enable gcc 7

One needs to setup `PATH` correctly in order to use `sudo`. 

```
e3-3.15.5 (master)$ scl enable devtoolset-7 bash
e3-3.15.5 (master)$ PATH=/usr/bin:$PATH 
e3-3.15.5 (master)$ echo ${PATH}
/usr/bin:/opt/rh/devtoolset-7/root/usr/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/ceauser/.local/bin:/home/ceauser/bin
```

```
e3-3.15.5 (master)$ bash e3.bash base
...

```

## Disabled gcc 7

```
$ exit
```
