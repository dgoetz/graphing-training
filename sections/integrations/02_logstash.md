!SLIDE subsectionnonum
#~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~ Logstash

!SLIDE small smbullets
# Logstash

* Receive events from various sources
  * Syslog
  * Windows eventlog
  * E-mail
  * SNMP traps
* Transform events
  * Transform timestamps
  * Resolve DNS names
  * Resolve GeoIP information
  * And so on
* Forward to various targets
  * Elasticsearch
  * Icinga (2)
  * E-mail
  * **Graphite**
* Can not store events

~~~SECTION:handouts~~~

****

Project: http://logstash.net

~~~ENDSECTION~~~


!SLIDE noprint
# Logstash
 
Logstash is a "pipe on steroids". Every event comes in via a input, goes through all filters and is sent through all outputs.

<img src="./_images/graphite-logstash.png" style="width:120%"/>


!SLIDE printonly
# Logstash
 
Logstash is a "pipe on steroids". Every event comes in via a input, goes through all filters and is sent through all outputs.

<img src="./_images/graphite-logstash.png" style="width:95%"/>


!SLIDE small smbullets
# Example Inputs, Filters and Outputs

* Input
 * `syslog`
 * `eventlog`
 * `file` (every line is one event)
 * `exec` (run an executable and use output as event)
* Filter
 * `grok` (predefined regex patterns)
 * `dns`
 * `geoip`
 * `throttle`
* Output
 * Elasticsearch
 * Redis
 * Logstash
 * Icinga (2)
 * Graphite


!SLIDE small
# Split into fields

Before:

    192.168.1.10 – guest [04/Dec/2013:08:54:23 +0100] "POST 
    /icinga-web/web/api/jsonHTTP/1.1" 200 788 
    "https://icinga-private.demo.netways.de/icinga-web/
    modules/web/portal" "Mozilla/5.0 (X11; Linux x86_64;)"

After:

    "http_clientip"    : "192.168.1.10",
    "http_auth"        : "guest",
    "timestamp"        : "04/Dec/2013:08:54:23 +0100",
    "http_verb"        : "POST",
    "http_request"     : "/icinga-web/web/api/json",
    "http_httpversion" : "1.1",
    "http_response"    : "200",
    "http_bytes"       : "788",
    "http_referrer"    : "https://graphite.demo.netways...",
    "http_agent"       : "Mozilla/5.0 (X11; Linux x86_64;)"


!SLIDE small
# Logstash Installation

Elastic, the company behind Logstash, provides repositories for all common Linux distributions.

    @@@Sh
    # rpm --import https://artifacts.elastic.co/\
    GPG-KEY-elasticsearch

    # cat <<EOF | sudo tee /etc/yum.repos.d/logstash.repo
    [logstash-5.x]
    name=Elastic repository for 5.x packages
    baseurl=https://artifacts.elastic.co/packages/5.x/yum
    gpgcheck=1
    gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
    enabled=1
    autorefresh=1
    type=rpm-md
    EOF

    # yum install logstash-5.4.1

Note: `java-openjdk` and the repo are already pre-installed on `graphing1.localdomain`.


!SLIDE smbullets
# Goal

* Read Apache logfiles
* Filter properly
* Write `bytes` and `returncode` to Graphite

Configuration files will be splitted into seperate files for each section.


!SLIDE small
# File Input

To read logfiles we need a simple `file` input.

File: `/etc/logstash/conf.d/input.conf`

    @@@Sh
    input {
      file {
        path => '/opt/graphite/storage/log/webapp/access.log'
      }
    }

Logstash doesn't provide any default configuration. For proper debugging it can be started manually:

    @@@Sh
    # /usr/share/logstash/bin/logstash -f [configuration-file]

In our case:

    @@@Sh
    # /usr/share/logstash/bin/logstash --path.settings \
    "/etc/logstash" -f /etc/logstash/conf.d/input.conf


!SLIDE small
# File Input Options

The `file` input supports some more useful options. Here are the most handy settings:

Option            | Description
----------------- | ------------
delimiter         | Set the delimiter of newlines. By default this is '\n'.
discover_interval | How often to search for new files when globs are used in `path`.
exclude           | Exclude specific files. Only useful if `path` includes glob(s).
sincedb_path      | Logstash can remember the last position it has read. This is helpful when you need to restart Logstash. The sincedb is a file that stores these position information
start_position    | Choose where to start reading files, at the beginning or at the end. By default Logstash will read from the beginning.


!SLIDE small
# Grok Filter

The `grok` filter comes with plenty of preconfigured patterns. One of these pattern can split Apache logs into seperate fields.

File: `/etc/logstash/conf.d/filter.conf`

    @@@Sh
    filter {
      grok {
        pattern => "%{COMMONAPACHELOG}"
      }
    
      date {
        match => ["timestamp", "dd/MM/yyyy:HH:mm:ss Z"]
        remove_field => ["timestamp"]
      }
    }

Logstash has its own `@timestamp` field. With the `date` filter we overwrite this implicit timestamp with the timestamp of the log entry.


!SLIDE small
# Grok Patterns

The `grok` filter plugin brings plenty of preconfigured regex patterns. Those built-int patterns can also be extended by your own. This table lists a small amount of common patterns, just to give you an overview. 

&nbsp;            | &nbsp;
----------------- | ------------------ 
SYSLOGBASE        | COMMONAPACHELOG 
COMBINEDAPACHELOG | SYSLOGTIMESTAMP 
SYSLOGFACILITY    | DATESTAMP_RFC822 
DATESTAMP_RFC2822 | IPV4 
IPV6              | MONTH 
YEAR              | HOUR 
MINUTE            |

~~~SECTION:handouts~~~

****

Grok Debugger: https://grokdebug.herokuapp.com/

~~~ENDSECTION~~~


!SLIDE small
# Graphite Output

Logstash brings a built-in plugin to forward filtered logs to Graphite. 

File: `/etc/logstash/conf.d/output.conf`

    @@@Sh
    output {
      graphite {
        host => "127.0.0.1"
        port => 2003
        metrics_format => "logstash.*"
        metrics => {
            "%{host}.apache_bytes"    => "%{bytes}"
            "%{host}.apache_response" => "%{response}"
        }
      }
    }

Start Logstash:

    @@@Sh
    # systemctl start logstash.service


!SLIDE small noprint
# The Problem

Depending on website requests, logs arrive in an irregular manner at Logstash which leads to irregular updates in Whisper files. If one slot in a Whisper archive represents 10 seconds, updates to this Whisper file will only be taken every 10 seconds. The result is data loss.

<center><img src="./_images/graphite-whisper-empty-slots.png"/></center>


!SLIDE small printonly
# The Problem

Depending on website requests, logs arrive in an irregular manner at Logstash which leads to irregular updates in Whisper files. If one slot in a Whisper archive represents 10 seconds, updates to this Whisper file will only be taken every 10 seconds. The result is data loss.

<center><img src="./_images/graphite-whisper-empty-slots.png" style="width:95%"/></center>
