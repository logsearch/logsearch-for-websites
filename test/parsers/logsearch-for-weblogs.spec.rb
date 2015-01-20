require 'test_utils'
require 'logstash/filters/grok'

describe 'All logsearch-for-weblogs parsers' do
  extend LogStash::RSpec
   
  config <<-CONFIG
    filter {
      #{File.read('target/logsearch-for-weblogs.filters.conf')}
    }
  CONFIG

  context 'nginx_combined log over syslog' do

    sample('@type' => 'syslog', '@message' => '<14>1 2015-01-16T15:17:17.046+0000 logsearch-workspace LOGSTASH - - [LOGSTASH@1.4.0 @type="nginx_combined"] 10.10.16.16 - - [16/Jan/2015:15:10:11 +0000] "GET /docs/workspace/develop-the-logsearch-website.html HTTP/1.1" 200 2166 "http://www.logsearch.io/docs/workspace/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36" 0.000') do
      #puts subject.to_hash.to_yaml

      insist { subject['tags'] } === ["syslog_standard", "nginx"]
      insist { subject['@type'] } === 'nginx_combined'
      insist { subject['@timestamp'] } == Time.iso8601('2015-01-16T15:10:11.000Z')

      insist { subject['request_method'] } == 'GET'
      insist { subject['request_uri'] } == '/docs/workspace/develop-the-logsearch-website.html'
      insist { subject['http_user_agent'] } == '"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36"'
    end

  end #context: nginx_combined log over syslog

end #describe: All logsearch-for-weblogs parsers
