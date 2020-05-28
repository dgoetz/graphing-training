!SLIDE subsection
# ~~~SECTION:MAJOR~~~ Provisioning

!SLIDE
# Provisioning

Grafana uses an active provisioning system over config files. Dashboards and
datasources can be defined via config file in the `provisioning/datasources` or
`provisioning/dashboards`.

The configuration is written in **YAML**

    @@@Sh
    cat /etc/grafana/provisioning/datasources/example.yaml
    apiVersion: 1

    deleteDatasources:
      - name: Graphite
      orgId: 1

    datasources:
      - name: Graphite
        type: graphite
        access: proxy
        orgId: 1
        url: http://localhost:8080
        password:
        user:

!SLIDE
# Provisioning

Dashboards can also be provisioned via local configuration files.

Beforehand the dashboard need to be exported in `json`, this can be done over
the GUI. These files can then be placed below the configured path.

    @@@Sh
    cat /etc/grafana/provisioning/dashboards/default.yaml
    apiVersion: 1

    providers:
    - name: 'default'
      orgId: 1
      folder: ''
      type: file
      disableDeletion: false
      updateIntervalSeconds: 10 #how often Grafana will scan for changed dashboards
      options:
        path: /var/lib/grafana/dashboards


!SLIDE
# Environment Variables

All options in the main configuration file `/etc/grafana/grafana.ini` can be
overwritten using environment variables.

`GF_<SectionName>_<KeyName>`

Example:

    @@@Sh
    # default section
    instance_name = ${HOSTNAME}

    As environment variable:
    export GF_DEFAULT_INSTANCE_NAME=grafana-instance-1


!SLIDE
# Configuration Management

The community provides configuration modules for different configuration management tools.

* Puppet
* Ansible
* Chef
* Saltstack
* Jsonet
