A robot for opencomputers. It walks around and navigates to waypoints right now.

![travis ci](https://travis-ci.org/justinbarrick/ambulator.svg?branch=master)

# Users

## Make a robot

Place the following in an Electronics Assembler:

* Case (Tier 3)
* Central Processing Unit (CPU) (Tier 3)
* Graphics Card (Tier 1)
* Internet Card
* Memory (Tier 3.5) x 2
* Screen (Tier 1)
* Keyboard
* Battery Upgrade (Tier 3)
* Inventory Controller Upgrade
* Inventory Upgrade
* Disk Drive
* Hard Disk Drive (Tier 3)
* EEPROM (Lua BIOS)

Place the OpenOS floppy in the disk drive and turn on your robot.

Type `install` to install the operating system. Reboot the robot.

## Create oppm floppy

Create a regular floppy disk and a Scrench. Place the scrench and floppy into
a crafter. You'll get a random floppy back. If it is not oppm, place it back
into the crafter with the Scrench until you get the oppm floppy.

Place the oppm floppy into the robot and run `install oppm`.

## Install ambulator

```
wget https://raw.githubusercontent.com/justinbarrick/ambulator/master/build/install-ambulator.lua
install-ambulator
```

To update:

```
install-ambulator
```

## Running

To run, run `ambulator` with x and y coordinates relative to the robot's location:

```
ambulator 5 10
ambulator -5 -3
```

You can also create a Waypoint block, place it and then list waypoints:

```
ambulator list
```

And then navigate to available waypoints:

```
ambulator waypointname
```

# Contributing

To build on any linux machine:

```
make build
```

To run the tests:

```
make test
```

Tests can be added in `tests/`.
