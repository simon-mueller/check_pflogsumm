#!/usr/bin/env python3
# Monitoring script to get statistics about postfix via pflogsumm

import subprocess
import re

maillog_path = "/var/log/mail.log"

returned_output = subprocess.check_output(["pflogsumm", "-d", "yesterday", "--detail", "0", "--bounce-detail", "0", "--deferral-detail", "0", "--reject-detail", "0", maillog_path])
lines=returned_output.decode("utf-8").splitlines()
stats={}
perfdata=""
for index,line in enumerate(lines):
    if index >= 5 and index <= 20:
        stripped_line = line.strip()
        value,space,key = stripped_line.partition("  ")
        if key and value:
                key=key.replace(" ","")
                key=key.replace("/","_")
                key=re.sub("\(.*","", key)
                perfdata+=key + "=" + value.strip()
                if key == "bytesreceived" or key == "bytesdelivered":
                    perfdata+=";1:999999)|"
                # elif key == "": # implement your own logic here
                elif key in [ "deferred", "bounced", "held", "discarded"]:
                    perfdata+=";1|"
                else: # defaults
                    perfdata+=";100;200;0;200|"
                stats[key.strip()]=value.strip()

print("P \"Postfix_Stats\"",perfdata.rstrip('|'), "Result is computed from values")
