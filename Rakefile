task :clean do
  rm_rf "target"
  mkdir "target"
end

desc "Builds filters"
task :build => :clean do
	puts "===> Building ..."
	mkdir_p 'target/kibana-dashboards'
	sh "vendor/addon-common/bin/build.sh src/parsers/logsearch-for-weblogs.filters.conf.erb > target/logsearch-for-weblogs.filters.conf"
	sh "vendor/addon-common/bin/build.sh src/kibana-dashboards/Geo-IP.json > target/kibana-dashboards/Geo-IP.json"
	puts "===> Artifacts:"
	puts `tree target`
end

desc "Runs tests against filters"
task :test => :build do
	puts "===> Testing ..."
	sh "vendor/addon-common/bin/test.sh"
end

desc "Loads sample Nginx data (from logsearch.io)"
task :load_sample_data do
	puts "===> Loading test data ..."
	INGESTOR_IP = "10.244.10.6"
  SAMPLE_DATA_URL = "https://s3-eu-west-1.amazonaws.com/ci-logsearch/logs/logsearch.io/logsearch.io-nginx-access-20150119.log.tar.gz"

  CONFIG_STRING = <<END
input {
  stdin {
    add_field => [ "@type", "nginx_combined" ]
  }
}

output {
  stdout {}

  syslog {
    host => "#{INGESTOR_IP}"
    port => 514
    protocol => "udp"
    rfc => "rfc5424"
    facility => "user-level"
    severity => "informational"
    structured_data => "@type=%{[@type]}"
  }
}
END
  puts "Importing data from #{SAMPLE_DATA_URL}"
  TODAY="#{Time.now.strftime('%d/%b/%Y')}"
  REPLACE_DATE_WITH_TODAY="sed -e 's/19\\/Jan\\/2015/#{TODAY.gsub('/','\/')}/g'"
  sh %Q[curl -s #{SAMPLE_DATA_URL} | tar xzO | #{REPLACE_DATE_WITH_TODAY} | vendor/logstash/bin/logstash agent -v -e '#{CONFIG_STRING}']
end
