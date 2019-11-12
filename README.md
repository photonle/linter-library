# Photon Linter Library

Let's start off.
- Do you just like flashy lights?
	- You don't need this.
- Do you not make your own vehicles?
	- You don't need this.

## What is this?

The photon linter library is a small collection of linters for Photon Sirens, Auto Components, Vehicles and such.

This means it finds dodgy stuff and tells you.

## How does it work?

The code itself is written in lua (and built for version 5.1). Running the linter is simple.

```bash
lua componentlint.lua <file1> [<file2>, [<file3>, [...]]]
```
Pretty easy, right? You can also do sirenlint.lua for sirens.

This spits out a bunch of stuff.
```
Test Dome_Light_Amber::Name started
Test Dome_Light_Amber::Name succeeded, performed 2 assertions.
Test Dome_Light_Amber::Model started
Test Dome_Light_Amber::Model succeeded, performed 4 assertions.
Test Dome_Light_Amber::Skin started
Test Dome_Light_Amber::Skin succeeded, performed 1 assertion.
Test Dome_Light_Amber::Bodygroups started
Test Dome_Light_Amber::Bodygroups succeeded, performed 1 assertion.
...
Test Whelen_Vertex::Name started
Test Whelen_Vertex::Name succeeded, performed 2 assertions.
Test Whelen_Vertex::Model started
Test Whelen_Vertex::Model succeeded, performed 4 assertions.
Test Whelen_Vertex::Skin started
Test Whelen_Vertex::Skin succeeded, performed 1 assertion.
Test Whelen_Vertex::Bodygroups started
Test Whelen_Vertex::Bodygroups succeeded, performed 1 assertion.
Stats:
    Files Failed: 0
    Components Checked: 112
    Tests Ran: 448
    Tests Succeeded: 448
    Tests Failed: 0
    Assertions: 842
```

The important thing. "tests failed". If that's more than 0, it spits out what failed. That normally shows something needs fixing.