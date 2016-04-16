require 'puppet'
require 'yaml'
require 'socket'

begin
  # Note influxdb-ruby gem v0.2.4 minimum
  require 'influxdb'
rescue LoadError => e
  Puppet.info "You need the `influxdb` gem v0.2.4 minimum to use this InfluxDB report processor"
end

# Check gem version
#Gem.loaded_specs['influxdb'].version < Gem::Version.create('0.2.4')

Puppet::Reports.register_report(:influxdb) do

  configfile = File.join([File.dirname(Puppet.settings[:config]), "influxdb.yaml"])
  raise(Puppet::ParseError, "InfluxDB report config file #{configfile} not readable") unless File.exist?(configfile)
  config = YAML.load_file(configfile)
  DEBUG = config[:debug]
  INFLUXDB_SERVER = config[:influxdb_server]
  INFLUXDB_PORT = config[:influxdb_port]
  INFLUXDB_USER = config[:influxdb_username]
  INFLUXDB_PASS = config[:influxdb_password]
  INFLUXDB_DB = config[:influxdb_database]

  desc <<-DESC
  Sends metrics from puppet agents reports to an InfluxDB server.
  DESC

  def process
    Puppet.info "Sending metrics for #{self.host} to InfluxDB"
    influxdb = InfluxDB::Client.new("#{INFLUXDB_DB}", {
      host: INFLUXDB_SERVER,
      username: INFLUXDB_USER,
      password: INFLUXDB_PASS,
      port: INFLUXDB_PORT,
      server: INFLUXDB_SERVER,
      retry: 4
    })
    self.metrics.each { |metric,data|
      data.values.each { |val| 
        key = "puppet #{metric} #{val[1]}".downcase.tr(" ", "_")
        value = val[2].to_f

        data = {
          values: { value: value },
          tags: { host: "#{self.host}" }
        }
        influxdb.write_point(key, data)
      }
    }
    self.resource_statuses.each { |resource_status,data|
      data.events.each { |val|
        # Convert time to someting more readable (country format ? in config file)
        # Push event at real time it occurs ?
        #if DEBUG
          Puppet.info "#{data.resource_type} #{data.title} #{val} #{val.status} at #{val.time}"
        #end
        events_m = 'events'
        data = {
         values: { text: "#{data.resource}" },
         tags: { host: "#{self.host}", resource_type: "#{data.resource_type}" , status: "#{val.status}" }
        }
        influxdb.write_point(events_m, data)
      }
    }
    Puppet.info "Reporting for #{self.host} to InfluxDB"
  end
end

