# Appendix C : GCC 7 within CentOS 7 : devtoolset-7

Even if there is the sudo bug [1] of devtoolset-7, we can use the standard e3 building system as well. Enjoy e3 with GCC7. 


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

```
e3-3.15.5 (master)$ scl enable devtoolset-7 bash
```

```
e3-3.15.5 (master)$ bash e3.bash base
...

```

## Disabled gcc 7

```
$ exit
```

## Reference
[1] https://bugzilla.redhat.com/show_bug.cgi?id=1319936
