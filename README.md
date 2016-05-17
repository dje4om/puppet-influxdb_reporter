influxdb_reporter
==============

Rework and updated version of Derek Tracy's report processor: https://forge.puppetlabs.com/tracyde/influxdb_reporter
Thx to him for this great idea to collect metrics of agents in InfluxDB ;)

Extended
--------
InfluxDB Reporter now push events to InfluxDB to allow you to display then to Grafana annotations !

Description
-----------

A Puppet report processor for sending metrics and events to an [InfluxDB](http://influxdb.com/) server.
Allow you to diplay Puppet events as [Grafana annotations](http://docs.grafana.org/reference/annotations).

Requirements
------------

This has been tested with this versions but it should work with older versions of Puppet:

* Puppet 3.8.x to Puppet 4.4.x
* PuppetServer 1.1.x to PuppetServer 2.3.x
* InfluxDB 0.9.4.2 to InfluxDB 0.11.1
* Gem influxdb 0.2.4 to influxdb 0.3.0

* Works on Passenger masters & PuppetServer masters

* based on report format v4 from puppet : https://docs.puppet.com/puppet/3.8/reference/format_report.html#report-format-4

Installation & Usage
--------------------

1.  Install the `influxdb` gem on your Puppet master

Legacy Webrick Masters or Passenger Masters
* [sudo] gem install cause
* [sudo] gem install influxdb

PuppetServer
* [sudo] puppetserver gem install cause
* [sudo] puppetserver gem install influxdb

You could have to restart your master depending on you deployment type.

2.  Deploy influxdb_reporter as a module in your Puppet code environment

3.  Update the `influxdb_server`, `influxdb_port`, `influxdb_username`, `influxdb_password`, 
    and `influxdb_database` variables in the `influxdb.yaml` file with your InfluxDB server 
    IP and port and copy the file to puppet master configuration directory. An example file is included.

    `/etc/puppet/` for Puppet 3.x
    `/etc/puppetlabs/puppet/` for Puppet 4.x

   setting influxdb_debug can be set to true to display events information in puppetserver logfile
   setting influxdb_events_measurement define the measurement name in influxdb database

4.  Enable pluginsync and reports on your master and clients in `puppet.conf`

        [master]
        report = true
        reports = influxdb
        pluginsync = true
        [agent]
        report = true
        pluginsync = true

5.  Run the Puppet client and sync the report as a plugin

Author
------

Forked from Derek Tracy <tracyde@gmail.com>

License
-------

    Author:: Derek Tracy (<tracyde@gmail.com>)
    Copyright:: Copyright (c) 2014 Derek Tracy
    License:: Apache License, Version 2.0

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
