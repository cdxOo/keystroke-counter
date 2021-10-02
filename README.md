# keystroke-counter

Linux/X11 utility to count and log keystrokes per time interval repeatedly,
requires "xinput".

## Usage

```bash
./keystroke-counter \
    --interval 60
    --log-file ./keystroke-counter.log
    --keyboard any
# interval:
#     time interval for grouping the keystrokes in seconds
#     (e.g. keystrokes per minute)
#     optional; default: 60
# log-file:
#     path to the log file for storing data
#     optional; default: './keystroke-counter.log'
# keyboard:
#     keyboard to take inputs from, see "xinput list"
#     e.g. --keyboard "AT Keyboard 2"; use --keyboard "any"
#     to take inputs from all recognized keyboard devices
#     optional; default: "any"

```

You might want this in your ~/.xinitrc so it's started 
background automatcially.

```bash
~/my/path/to/keystroke-counter --log-file ~/.my-log.log &
```

## Output

```bash
# start 1633142208 (interval=60; keyboard="AT Translated Set 2 keyboard")
1633142160 18
1633142220 73
1633142280 124
# stop 1633142335
```

First Column is the unix timestamp of the intervals start; second line
is the amount of keystrokes in that interval. Header line also logs
interval and keyboard arguments in case someone needs that.
