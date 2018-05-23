
# Example 0

Use Require and one module name

```
ioc (master)$ iocsh.bash cmds/0.cmd 
```

# Example 1

User Require and one module name with the specific version number

```
ioc (master)$ iocsh.bash cmds/1.cmd
```

# Example 2

Use iocInit

```
ioc (master)$ iocsh.bash cmds/2.cmd
```


# Example 3

## requirement

One should run the simulator first

```
e3-gconpi (master)$ ./simulator.sh
 
```

Open another terminal, and run the following :

```
ioc (master)$ iocsh.bash cmds/3.cmd "TOP=."
```

# Example 4

We add the iocStats into 3.cmd

```
ioc (master)$ iocsh.bash cmds/4.cmd "TOP=."
```


# Example 5

We add the autosave into 4.cmd

```
ioc (master)$ iocsh.bash cmds/5.cmd "TOP=."
```
