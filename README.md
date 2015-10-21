influxdb_reporter
==============

Just a little updated & tested version of Derek Tracy's report processor: https://forge.puppetlabs.com/tracyde/influxdb_reporter
Thx to him for this great idea to collect metrics of agents in InfluxDB ;)

Description
-----------

A Puppet report processor for sending metrics to an [InfluxDB](http://influxdb.com/) server.

Requirements
------------

This has been tested with this versions but it should work with older versions:

* Puppet 4.2.2
* PuppetServer 2.1.1
* InfluxDB 0.9.4.2
* Gem influxdb 0.2.2

Will be tested: 

* Puppet 3.7.x / 3.8.x
* Passenger Master & PuppetServer 1.1.2

Installation & Usage
--------------------

1.  Install the `influxdb` gem on your Puppet master

  Legacy Webrick Masters or Passenger Masters
        $ sudo gem install influxdb 
  PuppetServer
        $ sudo puppetserver gem install influxdb

You will need to restart your master

2.  Deploy influxdb_reporter as a module in your Puppet code environment

3.  Update the `influxdb_server`, `influxdb_port`, `influxdb_username`, `influxdb_password`, 
    and `influxdb_database` variables in the `influxdb.yaml` file with your InfluxDB server 
    IP and port and copy the file to puppet master configuration directory. An example file is included.

    `/etc/puppet/` for Puppet 3.x
    `/etc/puppetlabs/puppet/` for Puppet 4.x

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

Derek Tracy <tracyde@gmail.com>

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
