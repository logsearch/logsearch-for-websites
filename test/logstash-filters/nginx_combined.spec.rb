# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require 'logstash/filters/grok'

describe 'nginx_combined' do
    
  config <<-CONFIG
    filter {
      #{File.read('src/logstash-filters/snippets/nginx_combined.conf')}
    }
  CONFIG

  context 'geoip' do

     sample("@message" => '192.0.2.15 - - [06/Jun/2013:07:28:33 +0000] "GET /favicon.ico HTTP/1.1" 200 0 "-" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.94 Safari/537.36"') do

      # puts subject.to_hash.to_yaml

      insist { subject["tags"] } == [ 'nginx' ]
      insist { subject["@timestamp"] } == Time.iso8601("2013-06-06T07:28:33.000Z")

      insist { subject['remote_addr'] } == '192.0.2.15'
      insist { subject['remote_user'] } == '-'
      insist { subject['request_method'] } == 'GET'
      insist { subject['request_uri'] } == '/favicon.ico'
      insist { subject['request_httpversion'] } == '1.1'
      insist { subject['status'] } === 200
      insist { subject['body_bytes_sent'] } === 0
      insist { subject['http_referer'] }.nil?
      insist { subject['http_user_agent'] } == '"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.94 Safari/537.36"'

    end

    sample('@type' => 'nginx_combined', '@message' => '216.58.208.46 - - [16/Jan/2015:15:10:11 +0000] "GET /docs/workspace/develop-the-logsearch-website.html HTTP/1.1" 200 2166 "http://www.logsearch.io/docs/workspace/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36" 0.000') do

      insist { subject['tags'] } === ["nginx"]
      insist { subject['geoip']['ip']} === "216.58.208.46"
      insist { subject['geoip']['location']} === [-122.0574, 37.41919999999999]

    end

    sample('@type' => 'nginx_combined', '@message' => '216.58.208.46 - - [16/Jan/2015:15:10:11 +0000] "GET /docs/workspace/develop-the-logsearch-website.html HTTP/1.1" 200 2166 "http://www.logsearch.io/docs/workspace/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36" 0.000') do

      # puts subject.to_hash.to_yaml

      insist { subject['tags'] } === ["nginx"]
      insist { subject['user_agent']['name'] } === "Chrome"

    end

  end #context: geoip

end #describe: nginx_combined 

