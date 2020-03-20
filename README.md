# tt

## What is it?

Time tracking script using hledger and timeclock format. Get hledger from
[hledger.org](http://hledger.org/download.html). Read about the timeclock
format [here](http://hledger.org/timeclock.html).

## Why would I want this?

This makes it easy to keep track of how much time you spend on different
activities. You might want that informally to monitor productivity, or formally
for invoicing.

## How do I use this?

```sh
tt in email            # start reading email
tt switch my project   # stop reading email and start working on 'my project'
tt out                 # go to lunch
tt tail                # remember what you were doing before lunch
tt i 13:00 my project  # forgot to clock in at 1PM, log the time explicitly
tt sw my other project # start working on 'my other project'
tt o 16:00             # forgot to clock out; log it as 4PM explicitly
```

If you only care about how much you're working, and not what you're working on,
then it's even easier. You can just use `tt i` when you start working, and `tt
o` when you stop. The activity will default to "work."

### Usage

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
```
