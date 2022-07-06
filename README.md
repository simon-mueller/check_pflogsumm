# check_pflogsumm
Active monitoring check to keep track of your postfix statistics via parsing pflogsumm output


## Usage

1. Place check_pflogsumm in your `/usr/lib/check_mk_agent/local/86400/` directory.
    * The check will be executed every 24 hours and cached in the meantime
    * The check looks into the last 24 hours of postfix's logfiles and creates statistics
1. Inventorize your mx host
1. Add discovered check to your service configuration of the host



## Output

```
root@mx:~# /usr/lib/check_mk_agent/local/86400/check_mailstats
P "Postfix_Stats" received=8;0:999999|delivered=8;0:999999|forwarded=1;0:999999|deferred=0;0:999999|bounced=0;0:999999|rejected=9;0:999999|rejectwarnings=0;0:999999|held=0;0:999999|discarded=0;0:999999|bytesreceived=220373;0:999999|bytesdelivered=220537;0:999999|senders=8;0:999999|sendinghosts_domains=8;0:999999|recipients=1;0:999999 Result is computed from values
```

## Dependencies

* perl
* pflogsumm (found in postfix-perl-scripts on EL distributions)

## Compatibility

This check can easily be modified so that it exits with return codes 0,1,2,3 and some arguments to set thresholds. Thus it would be suitable also for other monitoring solutions like Nagios, Icinga, etc. as well.
