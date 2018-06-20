# nagios_nifi_checks

Some nagios to momitor [Apache NiFi](https://nifi.apache.org/)


Susscesfull messages

Check if queuedCount from last status history item is greater than a threshold

```bash
Usage: nifi_successful_check.rb [options]
  -m, --mode MODE                  [ http | https ]
  -s, --server SERVER              nifi.my.org
  -p, --port PORT                  9443
  -c, --cert CERT                  /opt/nifi/secure/admin-cert.pem
  -k, --cert_key CERT_KEY          /opt/nifi/secure/admin-private-key.pem
  -i, --id ID                      103e129b-1d51-1cb9-b465-787fe022168e
  -t, --threshold THRESHOLD        5
  -v, --verbose                    Verbose
  -h, --help                       Displays Help
```

```bash
 ./nifi_successful_check.rb -i 103e129b-1d51-1cb9-b465-787fe022168e -t 720 -c /opt/nifi/secure/admin-cert.pem -k /opt/nifi/secure/admin-private-key.pem -m https -s connect-prod-1.hmobile-servers.com -p 9443
 No messages in the last 720 minutes
```

Failed messages

Check if there is an increment in queuedCount from an interval (From now to threshold in minutes ).

```bash
Usage: nifi_failed_check.rb [options]
  -m, --mode MODE                  [ http | https ]
  -s, --server SERVER              nifi.my.org
  -p, --port PORT                  9443
  -c, --cert CERT                  /opt/nifi/secure/admin-cert.pem
  -k, --cert_key CERT_KEY          /opt/nifi/secure/admin-private-key.pem
  -i, --id ID                      103e129b-1d51-1cb9-b465-787fe022168e
  -t, --threshold THRESHOLD        5
  -v, --verbose                    Verbose
  -h, --help                       Displays Help

```

```bash
./nifi_failed_check.rb -i 103e129c-1d51-1cb9-9552-bb35180e8824 -t 3 -c /opt/nifi/secure/admin-cert.pem -k /opt/nifi/secure/admin-private-key.pem -m https -s connect-prod-1.hmobile-servers.com -p 9443
No faliled messages
```

