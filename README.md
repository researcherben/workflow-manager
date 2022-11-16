# workflow manager

Document the commands used and the results of those commands.

# command line use

    ./run_workflow.py --help
    usage: run_workflow.py [-h] [-s CONFIG_SCHEMA] configuration_filename

    positional arguments:
      configuration_filename
                            name of JSON file containing workflow and
                            configuration parameters

    optional arguments:
      -h, --help            show this help message and exit
      -s CONFIG_SCHEMA, --config_schema CONFIG_SCHEMA
                            schema for config

# example use

    ./run_workflow.py file.json --config_schema config_schema.json 
    posix.uname_result(sysname='Linux', nodename='0321124f', release='4.1.78-linuxkit', version='#1 SMP Mon Nov 8 10:21:19 UTC 2021', machine='x86_64')
    sys.version_info(major=3, minor=6, micro=9, releaselevel='final', serial=0)
    **************************************
    ==== command ====
     pwd
    ==== start time %Y-%m-%d %H:%M:%S ====
     2022-11-16 23:50:52
    ==== done time %Y-%m-%d %H:%M:%S ====
     2022-11-16 23:50:52
    ==== elapsed time (seconds) ====
     0
    ==== return code ====
     0
    ==== stdout ====
     /scratch

    ==== stderr ====
    None
    **************************************
    ==== command ====
     ls -l
    ==== start time %Y-%m-%d %H:%M:%S ====
     2022-11-16 23:50:52
    ==== done time %Y-%m-%d %H:%M:%S ====
     2022-11-16 23:50:52
    ==== elapsed time (seconds) ====
     0
    ==== return code ====
     0
    ==== stdout ====
     total 32
    -rw-r--r-- 1 root root  337 Nov 16 23:45 config_schema.json
    -rw-r--r-- 1 root root 2572 Nov 16 23:30 Dockerfile
    -rw-r--r-- 1 root root   74 Nov 16 22:59 file.json
    -rw-r--r-- 1 root root 3241 Nov 16 23:42 Makefile
    -rw-r--r-- 1 root root  528 Nov 16 23:03 README.md
    -rw-r--r-- 1 root root   74 Nov 16 23:27 requirements.txt
    -rwxr--r-- 1 root root 4241 Nov 16 23:41 run_workflow.py

    ==== stderr ====
    None



Schema generated using
<https://www.liquid-technologies.com/online-json-to-schema-converter>

