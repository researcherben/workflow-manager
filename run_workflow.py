#!/usr/bin/env python3

"""
Run a sequence of commands based on entries in a JSON file. 


python3 run_workflow.py file.json | tee file.log

"""

# This script uses
# https://docs.python.org/3/library/typing.html
# https://realpython.com/lessons/type-hinting/

from datetime import datetime
import sys
import json
from jsonschema import validate  # type: ignore
import logging
import subprocess # https://docs.python.org/3/library/subprocess.html
import argparse   # https://docs.python.org/3/library/argparse.html
import os # path, uname

#https://realpython.com/python-subprocess/


def run_command(command_str: str) -> dict:
    """
    """

    command_list = command_str.split(" ")

    time_format = "%Y-%m-%d %H:%M:%S"

    time_before = datetime.today()

    if sys.version_info.major == 3 and sys.version_info.minor >= 7:
        result = subprocess.run(command_list, capture_output=True, shell=True)
    else: # needed for Python 3.6; see https://stackoverflow.com/a/53209196/1164295
        result = subprocess.run(command_list, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    time_after = datetime.today()

#result: CompletedProcess(args=['ls', '-l', '/dev/null'], returncode=0, stdout=b'crw-rw-rw-  1 root  wheel    3,   2 Nov 16 16:22 /dev/null\n', stderr=b'')

    result_dict = {"command": command_str,
                   "start time "+time_format: time_before.strftime(time_format),
                   "done time "+time_format: time_after.strftime(time_format),
                   "elapsed time (seconds)": (time_after-time_before).seconds,
                   "return code": result.returncode,
                   "stdout": result.stdout.decode("utf-8") ,
                   "stderr": result.stderr.decode("utf-8") }

    return result_dict

if __name__ == "__main__":

    theparser = argparse.ArgumentParser()

    # required positional argument
    # it is possible to constrain the input to a range;
    # see https://stackoverflow.com/a/25295717/1164295
    theparser.add_argument(
        "config_filename",
        metavar="configuration_filename",
        type=str,
        default="file.json",
        help="name of JSON file containing workflow and configuration parameters",
    )

    theparser.add_argument(
        "-s", "--config_schema",
        dest="config_schema",
        type=str,
        help="schema for config"
    )

    args = theparser.parse_args()

    if os.path.isfile(args.config_filename):
        with open(args.config_filename,'r') as file_handle:
            try:
                config_data = json.load(file_handle)
            except json.decoder.JSONDecodeError:
                print("ERROR: configuration file does not appear to be valid JSON. Exiting...\n", file=sys.stderr)
                sys.exit(1)
    else: # file didn't exist
        print("ERROR: specified configuration file name '"+str(args.config_filename)+"' not found. Exiting...\n", file=sys.stderr)
        sys.exit(1)

    # at this point 1) we have a file and 2) the file contains valid JSON

    if args.config_schema:
       if os.path.isfile(args.config_schema):
           with open(args.config_schema,'r') as file_handle:
               try:
                  config_schema = json.load(file_handle)
               except json.decoder.JSONDecodeError:
                print("ERROR: schema file does not appear to be valid JSON. Exiting...\n", file=sys.stderr)
                sys.exit(1)
       else: # file didn't exist
           print("ERROR: specified schema file name '"+str(args.config_schema)+"' not found. Exiting...\n", file=sys.  stderr)
           sys.exit(1)
       # TODO: check schema
       try:
           validate(instance=config_data, schema=config_schema)
       except Exception as err:
           print("validation of config JSON against schema failed. Exiting...\n", file=sys.stderr)
           sys.exit(1)

    print(os.uname())
    print(sys.version_info)

    for command in config_data["workflow commands"]:
        result_dict = run_command(command)
        print("**************************************")

        for k,v in result_dict.items():
            if v=="":
                print("==== "+k+" ====\nNone")
            else:
                print("==== "+k+" ====\n",v)



