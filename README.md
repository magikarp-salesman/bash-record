# bash-record

This is a bash script useful to record tty sessions into a file and easily replay it at a later time, this script packages and creates a compressed ```<file>.script``` that can be run on other terminal using bash conveniently.

It makes use of the ```script``` and ```scriptreplay``` tools by util-linux and should work with any version as long as they are available on your distro

## Requirements

* script
* scriptreplay
* bash
* base64
* mktemp
* gzip

## How to install

Source the script onto your shell

```shell
$ git clone https://github.com/magikarp-salesman/bash-record.git
$ source ./bash_record/bash_record.sh
```

or

```shell
$ . ./bash_record/bash_record.sh
```
## How to use

To record a new session type:

```shell
$ record_ this_is_how_you_use_ssh
```

This will start a new shell and record everything you type with your own timings, to stop the recording just exit the shell with **exit** or **ctrl+d**

The recording will start and you will have a new file as so:

```shell
root@beaglebone:~/recordings # ls -la
total 12
drwxr-xr-x  2 root root 4096 Jan 24 14:32 .
drwx------ 29 root root 4096 Jan 24 14:32 ..
-rw-r--r--  1 root root 1186 Jan 24 14:32 this_is_how_you_use_ssh.script
root@beaglebone:~/recordings #
```

To play it again type:
```shell
$ bash this_is_how_you_use_ssh.script
```

Now you can send/attach this file to any message and the person will be able to watch your local recording as long as they have the required tools (a message will be shown if you miss any of the dependencies)

If you need to replay it on a faster pace you can add a multiplier next to it as so:
```shell
$ bash this_is_how_you_use_ssh.script 3
```

This will play the same recording 3x faster.

**Note:** The script automatically removes any long delays on the final replay, for instance if you start a recording and the output and input stops for 1 hour (if you stop working to have lunch and then come back) the final output will only show 10s difference in that specific part of the replay.
