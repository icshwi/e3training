# Appendix D : GCC 8 within CentOS 7 : devtoolset-8

Even if there is the sudo bug [1] of devtoolset-8, we can use the standard e3 building system as well. Enjoy e3 with GCC8. 


## Setup development tool

```
$ yum install centos-release-scl
$ yum-config-manager --enable rhel-server-rhscl-7-rpms
```

* gcc8

```
$ yum install devtoolset-8
```

## Enable gcc 8

```
$ scl enable devtoolset-8 bash
```

```
$ bash e3.bash base
...

```

## Disabled gcc 8

```
$ exit
```

## Reference
[1] https://bugzilla.redhat.com/show_bug.cgi?id=1319936
