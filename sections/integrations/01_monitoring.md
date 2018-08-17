!SLIDE subsectionnonum
#~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~ Graph Monitoring


!SLIDE
# Graph Monitoring

Icinga can be used to monitor nearly anything. It goes without saying that there is a way you can monitor also your graphs with it.

* `check_graphite` plugin to check graphs:
 * Set any metric path
 * Set thresholds
 * Set timeframe
 * Apply function on target metric

**Note:** The `check_graphite` plugin and its dependency `rubygem-rest-client` are already pre-installed on "graphing1.localdomain".

~~~SECTION:handouts~~~
****

Project: https://github.com/obfuscurity/nagios-scripts<br/>
Docs: http://obfuscurity.com/2012/05/Polling-Graphite-with-Nagios

~~~ENDSECTION~~~


!SLIDE noprint small
# Graph Monitoring

Add a new service to one of your hosts to check metrics from Graphite. Ideally the datapoints you are checking do not come from Icinga itself. The CheckCommand for the `check_graphite` plugin is provided via Icinga Template Library (ITL).

File: **/etc/icinga2/training/services.conf**

    @@@Sh
    apply Service "graphite-load" {
      import "generic-service"

      check_command = "graphite"

      vars.graphite_url = "http://graphite"
      vars.graphite_metric = "collectd.graphing1.load.load.shortterm"
      vars.graphite_warning = 1
      vars.graphite_critical = 2
      vars.graphite_duration = 5

      assign where host.name == "graphing1.localdomain"
    }

Validate the configuration and reload Icinga 2:

    @@@Sh
    # icinga2 daemon -C
    # systemctl reload icinga2.service


!SLIDE printonly
# Graph Monitoring

Add a new service to one of your hosts to check metrics from Graphite. Ideally the datapoints you are checking do not come from Icinga itself. The CheckCommand for the `check_graphite` plugin is provided via Icinga Template Library (ITL).

File: **/etc/icinga2/training/services.conf**

    @@@Sh
    apply Service "graphite-load" {
      import "generic-service"

      check_command = "graphite"

      vars.graphite_url = "http://graphite"
      vars.graphite_metric = "collectd.graphing1.load.\
        load.shortterm"
      vars.graphite_warning = 1
      vars.graphite_critical = 2
      vars.graphite_duration = 5

      assign where host.name == "graphing1.localdomain"
    }

Validate the configuration and reload Icinga 2:

    @@@Sh
    # icinga2 daemon -C
    # systemctl reload icinga2.service
