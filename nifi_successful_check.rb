#!/usr/bin/ruby

require 'colorize'
require 'optparse'
require 'pp'

require 'nifi_sdk_ruby'

OK       = 0
WARNING  = 1
CRITICAL = 2
UNKNOWN  = 3

options = {
  :mode      => 'http',
  :server    => 'localhost',
  :port      => 8080,
  :cert      => nil,
  :cert_key  => nil,
  :id        => nil,
  :threshold => nil,
}

OptionParser.new do |o|
    o.banner = "Usage: nifi_successful_check.rb [options]"

    o.on('-m', '--mode MODE', String, '[ http | https ]') { |v| options[:mode] = v }
    o.on('-s', '--server SERVER', String, 'nifi.my.org') { |v| options[:server] = v }
    o.on('-p', '--port PORT', Integer, '9443') { |v| options[:port] = v }
    o.on('-c', '--cert CERT', String, '/opt/nifi/secure/admin-cert.pem') { |v| options[:cert] = v }
    o.on('-k', '--cert_key CERT_KEY', String, '/opt/nifi/secure/admin-private-key.pem') { |v| options[:cert_key] = v }
    o.on('-i', '--id ID', String, '103e129b-1d51-1cb9-b465-787fe022168e') { |v| options[:id] = v }
    o.on('-t', '--threshold THRESHOLD', Integer, '5') { |v| options[:threshold] = v }
    o.on('-v', '--verbose', 'Verbose') { |v| options[:verbose] = v }
    o.on('-h', '--help', 'Displays Help') do
      puts o
      exit
    end
end.parse!

argument_errors = ''
options.each do |k, v|
    argument_errors.concat("#{k} argument is mandatory.\n") if options[k.to_sym].nil?
end

unless argument_errors.empty?
    puts argument_errors.red
    exit 1
end

nifi_client = Nifi.new(
  :schema   => options[:mode],
  :host     => options[:server],
  :port     => options[:port],
  :cert     => options[:cert],
  :cert_key => options[:cert_key]
)

nifi_client.set_debug true

history = nifi_client.get_conection_status_history(options[:id])
history_items = history['statusHistory']['aggregateSnapshots']

if options[:threshold].to_i > history_items.count
  puts "No enough statusHistory (#{history_items.count}) to this threshold (#{options[:threshold]})."
  exit WARNING
end

queued_count = history_items.last['statusMetrics']['queuedCount'] - history_items[-(options[:threshold].to_i)]['statusMetrics']['queuedCount']

if options[:verbose]
  puts "first (#{options[:threshold]} ago):"
  puts history_items[-(options[:threshold].to_i)]['statusMetrics']['queuedCount']
  puts 'last (Now):'
  puts history_items.last['statusMetrics']['queuedCount']
  puts 'queued_count:'
  puts queued_count
end

if queued_count <= 0
  puts "No messages in the last #{options[:threshold]} minutes"
  exit CRITICAL
end

  puts "#{queued_count} messages in the last #{options[:threshold]} minutes"
exit OK
