require 'test_utils'
require 'logstash/filters/grok'

describe 'nginx_combined' do
  extend LogStash::RSpec
    
  config <<-CONFIG
    filter {
      #{File.read('src/parsers/snippets/nginx_combined.conf')}
    }
  CONFIG

  context 'geoip' do

    sample('@type' => 'nginx_combined', '@message' => '216.58.208.46 - - [16/Jan/2015:15:10:11 +0000] "GET /docs/workspace/develop-the-logsearch-website.html HTTP/1.1" 200 2166 "http://www.logsearch.io/docs/workspace/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36" 0.000') do
    
      #puts subject.to_hash.to_yaml

      insist { subject['tags'] } === ["nginx"]
      insist { subject['geoip']['ip']} === "216.58.208.46"
      insist { subject['geoip']['location']} === [-122.0574, 37.41919999999999]

    end

  end #context: geoip

end #describe: nginx_combined 

