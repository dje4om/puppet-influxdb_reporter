require 'puppet'
require 'yaml'
require 'socket'

# TODO: allow to send events in specific database
# TODO: define default values for params

begin
  require 'influxdb'
  raise LoadError if Gem.loaded_specs['influxdb'].version < Gem::Version.create('0.2.4')
rescue LoadError
  Puppet.info "You need the `influxdb` gem v0.2.4 minimum to use this InfluxDB report processor"
end

Puppet::Reports.register_report(:influxdb) do
  configfile = File.join([File.dirname(Puppet.settings[:config]), "influxdb.yaml"])
  raise(Puppet::ParseError, "InfluxDB report config file #{configfile} not readable") unless File.exist?(configfile)
  config = YAML.load_file(configfile)
  INFLUXDB_DEBUG = config[:influxdb_debug]
  INFLUXDB_SERVER = config[:influxdb_server]
  INFLUXDB_PORT = config[:influxdb_port]
  INFLUXDB_RETRY = config[:influxdb_retry]
  INFLUXDB_USER = config[:influxdb_username]
  INFLUXDB_PASS = config[:influxdb_password]
  INFLUXDB_DB = config[:influxdb_database]
  INFLUXDB_PUSHEVENTS = config[:influxdb_pushevents]
  INFLUXDB_EVENTS_MEASUREMENT = config[:influxdb_events_measurement]

  desc <<-DESC
  Sends metrics from puppet agents reports to an InfluxDB server.
  DESC

  def process
    influxdb = InfluxDB::Client.new(INFLUXDB_DB, {
      host: INFLUXDB_SERVER,
      username: INFLUXDB_USER,
      password: INFLUXDB_PASS,
      port: INFLUXDB_PORT,
      server: INFLUXDB_SERVER,
      retry: INFLUXDB_RETRY
    })
    # Metrics from agents
    # Always sent if agent run successfuly
    beginning_time = Time.now
    self.metrics.each do |metric,data|
      data.values.each do |val| 
        key = "puppet #{metric} #{val[1]}".downcase.tr(" ", "_")
        value = val[2].to_f

        data = {
          values: { value: value },
          tags: { host: self.host.to_s }
        }
        influxdb.write_point(key, data)
	  end
	end
    end_time = Time.now
    Puppet.info "Metrics for #{self.host} submitted to InfluxDB in #{(end_time - beginning_time)*1000} ms"
    if INFLUXDB_PUSHEVENTS
      # Events on resources
      # success/failure/noop/audit events are sent
      event = false
      beginning_time = Time.now
      self.resource_statuses.each do |resource_status,data|
        data.events.each do |val|
          if INFLUXDB_DEBUG
            Puppet.info "#{data.resource_type} #{data.title} #{val} #{val.status} took #{data.evaluation_time} s"
            Puppet.info "Time event occurs from report: #{val.time}"
            Puppet.info "Current time: #{time}"
            # Allow to see latency impact of sending events
            Puppet.info "Time Drift between current time and event time in report: #{Time.now - val.time} ms"
          end
          event = true
          measurement = INFLUXDB_EVENTS_MEASUREMENT
          data = {
           values: { resource: data.resource.to_s,
                     event:"#{data.resource_type} #{data.title} #{val}",
                     evaluation_time: data.evaluation_time },
           tags: { host: self.host.to_s,
                   resource_type: data.resource_type.to_s,
                   status: val.status.to_s },
           # Push event at time it occurs from report
           timestamp: val.time.to_i
          }
          influxdb.write_point(measurement, data)
	    end
	  end
      end_time = Time.now
      # To display only if events occurs
      if event
        Puppet.info "Events for #{self.host} submitted to InfluxDB in #{(end_time - beginning_time)*1000} ms"
      end
    end
  end
end

