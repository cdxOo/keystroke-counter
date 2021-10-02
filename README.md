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
