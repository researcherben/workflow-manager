#!/usr/bin/env bash

# deliberately cause this script to fail if certain conditions (explained below) are met.
# Why: explicitly failing reduces the risk of hidden bugs
# For more detailed explanation, see https://gist.github.com/mohanpedala/1e2ff5661761d3abd0385e8223e16425
set -euxo pipefail

# -e     When this option is on, if a simple command fails for any of the reasons listed in Consequences of
#        Shell  Errors or returns an exit status value >0, and is not part of the compound list following a
#        while, until, or if keyword, and is not a part of an AND  or  OR  list,  and  is  not  a  pipeline
# 
#        preceded by the ! reserved word, then the shell shall immediately exit.
# -u     The shell shall write a message to standard error when it tries to expand a variable that  is  not
#        set and immediately exit. An interactive shell shall not exit.
#
# -x     The  shell shall write to standard error a trace for each command after it expands the command and
#        before it executes it. It is unspecified whether the command that turns tracing off is traced.
#
# -o pipefail
#        This setting prevents errors in a pipeline from being masked. 

#************************************************
# Real refers to actual elapsed time; User and Sys refer to CPU time used only by the process.
# 
# Real is wall clock time - time from start to finish of the call. This is all elapsed time including time slices used by other processes and time the process spends blocked (for example if it is waiting for I/O to complete).
#
# User is the amount of CPU time spent in user-mode code (outside the kernel) within the process. This is only actual CPU time used in executing the process. Other processes and time the process spends blocked do not count towards this figure.
# 
# Sys is the amount of CPU time spent in the kernel within the process. This means executing CPU time spent in system calls within the kernel, as opposed to library code, which is still running in user-space. Like 'user', this is only CPU time used by the process. See below for a brief description of kernel mode (also known as 'supervisor' mode) and the system call mechanism.

#************************************************
echo $HOSTNAME
uname -a

echo $(date '+%Y-%m-%d %H:%M:%S')

#************************************************
# run commands

time pwd
# show exit code; redundant when "set -e" is present
echo $?

time ls -hal
# show exit code; redundant when "set -e" is present
echo $?


# EOF
