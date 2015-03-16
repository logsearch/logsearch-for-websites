# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require 'logstash/filters/grok'

describe 'All logsearch-for-weblogs parsers' do
   
  config <<-CONFIG
    filter {
      #{File.read('target/logstash-filters-default.conf')}
    }
  CONFIG

  context 'nginx_combined' do

    sample('@type' => 'nginx_combined', '@message' => '10.10.16.16 - - [16/Jan/2015:15:10:11 +0000] "GET /docs/workspace/develop-the-logsearch-website.html HTTP/1.1" 200 2166 "http://www.logsearch.io/docs/workspace/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36" 0.000') do
      #puts subject.to_hash.to_yaml

      insist { subject['tags'] } === ["nginx"]
      insist { subject['@type'] } === 'nginx_combined'
      insist { subject['@timestamp'] } == Time.iso8601('2015-01-16T15:10:11.000Z')

      insist { subject['request_method'] } == 'GET'
      insist { subject['request_uri'] } == '/docs/workspace/develop-the-logsearch-website.html'
      insist { subject['http_user_agent'] } == '"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36"'
    end

  end #context: nginx_combined 

  context 'apache_combined' do
    sample('@type'=>'apache_combined', "@message" => '192.168.0.39 - - [31/Jul/2014:07:25:53 -0500] "GET /spread-betting/wp-includes/js/jquery/jquery.js?ver=1.11.0 HTTP/1.1" 200 96402 "http://origin-www.cityindex.co.uk/spread-betting/" "GomezAgent 2.0"') do

      insist { subject['tags'] } === ["apache"]

      insist { subject["@timestamp"] } == Time.iso8601("2014-07-31T12:25:53.000Z")

      insist { subject['clientip'] } == '192.168.0.39'
      insist { subject['ident'] } == '-'
      insist { subject['auth'] } == '-'
      insist { subject['timestamp'] } == '31/Jul/2014:07:25:53 -0500'
      insist { subject['verb'] } == 'GET'
      insist { subject['request'] } == '/spread-betting/wp-includes/js/jquery/jquery.js?ver=1.11.0'
      insist { subject['httpversion'] } === '1.1'
      insist { subject['response'] } === 200
      insist { subject['bytes'] } === 96402
      insist { subject['referrer'] } === "\"http://origin-www.cityindex.co.uk/spread-betting/\""
      insist { subject['agent'] } == '"GomezAgent 2.0"'
    end
  end

end #describe: All logsearch-for-weblogs parsers
