# tt

Time tracking script using hledger and timeclock format.

## Examples

```sh
tt in email            # start reading email
tt switch my project   # stop reading email and start working on 'my project'
tt out                 # go to lunch
tt tail                # remember what you were doing before lunch
tt i 13:00 my project  # forgot to clock in at 1PM, log the time explicitly
tt sw my other project # start working on 'my other project'
tt o 16:00             # forgot to clock out; log it as 4PM explicitly
```

## Usage

```
Usage: tt [COMMAND] [ARGS]
Track time

i|in                "Time in" to begin a task. Args: [optional date] [task name]
o|out               "Time out" to end a task. Args: [optional date]
s|stat              Show the current status (last line in the timeclock file).
b|bal               Show daily balances.
n|sw|next|switch    End (time out of) the current task, and begin the next.
                    task. New task name is the next arg.
e|edit              Edit the timeclock file with ${EDITOR}.
t|tail              Show the last 10 lines of the ledger
```
