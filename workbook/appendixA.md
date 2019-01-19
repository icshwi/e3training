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




------------------
[:arrow_backward:](README.md)  | [:arrow_up_small:](appendixA.md)  | [:arrow_forward:](appendixB.md)
:--- | --- |---: 
[README](README.md) | [Chapter 2](appendixA.md) | [Appendix B](appendixB.md)



