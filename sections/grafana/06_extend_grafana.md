!SLIDE
# Community

Apart from the default panels and graphs, the Grafana community provides a bunch of
other plugins to extend visualization possibilities or datasource options.

Pre designed dashboards can also be found in the community, or datasources provide own
dashboards to have a overview over the backend.

```
Community Plugins:
https://grafana.com/plugins
```

```
Community Dashboards:
https://grafana.com/dashboards
```

```
Community Discourse:
https://community.grafana.com/
```

!SLIDE
# Extend Grafana

To extend Grafana with plugins, we can use the `grafana-cli`.

Per default on linux systems plugins get installed to the directory `/var/lib/grafana/plugins`.

    @@@Sh
    $ grafana-cli plugins list-remote
    $ grafana-cli plugins install <plugin-id>
    $ grafana-cli plugins install <plugin-id> <version>
    $ grafana-cli plugins update-all
    $ grafana-cli plugins update <plugin-id>
