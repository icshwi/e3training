# Appendix A : Build System Troubleshoting 

## Case 1

* Problem : when we run `make vars` or `make build`, we may see the following message:

```
configure/CONFIG:20: /epics/base-7.0.1.1/require/3.0.4/configure/CONFIG: No such file or directory
/epics/base-7.0.1.1/require/3.0.4/configure/RULES_SITEAPPS: No such file or directory
make: *** No rule to make target `/epics/base-7.0.1.1/require/3.0.4/configure/RULES_SITEAPPS'.  Stop.
```

* Solution : Please check `EPICS_BASE` variable in the `configure/RELEASE` or `configure/RELEASE_DEV` file. And please check the physical location of `EPICS_BASE` as follows:
```
ls -lta /epics/base-7.0.1.1/require/3.0.4/
```

* Explaination :  Most case, the system doesn't have the specific EPICS base and its require module. To define the existent and would-like-to-use system must be done within `configure/RELEASE` or `configure/RELEASE_DEV`. 

* Practical Solution 

```
echo "EPICS_BASE=/home/root/epics/base-7.0.1.1" > configure/RELEASE_DEV.local
```

## Case 2

* Problem : when we run `make install` or `make devinstall`, we may see the following message:

```
rm: cannot remove '..../lib/linux-x86_ 64': Directory not empty

rm: cannot remove '..../lib/linux-x86_64/.nfs000000004c0de98d00000007': Device or resource busy
```
* Solution : Plese check whether the corresponding IOC is running in somewhere through NFS. We have to stop an IOC, and exit any running process, then we can delete this directory if we would like to install new one again. What meas `.nfsXXXX` can be found in http://nfs.sourceforge.net/#faq_d2

------------------
[:arrow_backward:](README.md)  | [:arrow_up_small:](appendixA.md)  | [:arrow_forward:](appendixB.md)
:--- | --- |---: 
[README](README.md) | [Chapter 2](appendixA.md) | [Appendix B](appendixB.md)



