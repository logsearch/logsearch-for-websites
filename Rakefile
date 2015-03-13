require 'erb'

task :clean do
  mkdir_p "target"
  rm_rf "target/*"
end

desc "Builds filters & dashboards"
task :build => :clean do
  puts "===> Building ..."
  compile_erb 'src/logstash-filters/default.conf.erb', 'target/logstash-filters-default.conf'

  mkdir_p 'target/kibana-dashboards'
  compile_erb 'src/kibana-dashboards/Geo-IP.json', 'target/kibana-dashboards/Geo-IP.json'

  puts "===> Artifacts:"
  puts `tree target`
end

desc "Runs unit tests against filters & dashboards"
task :test => :build do
  puts "===> Testing ..."
  sh %Q[ JAVA_OPTS="$JAVA_OPTS -XX:+TieredCompilation -XX:TieredStopAtLevel=1" vendor/logstash/bin/logstash rspec $(find test -name *spec.rb) ]
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
    structured_data => "LOGSTASH@42 @type=%{[@type]}"
  }
}
END
  puts "Importing data from #{SAMPLE_DATA_URL}"
  TODAY="#{Time.now.strftime('%d/%b/%Y')}"
  REPLACE_DATE_WITH_TODAY="sed -e 's/19\\/Jan\\/2015/#{TODAY.gsub('/','\/')}/g'"
  sh %Q[curl -s #{SAMPLE_DATA_URL} | tar xzO | #{REPLACE_DATE_WITH_TODAY} | vendor/logstash/bin/logstash agent -v -e '#{CONFIG_STRING}']
end

def compile_erb(source_file, dest_file)
  if File.extname(source_file) == '.erb'
    output = ERB.new(File.read(source_file)).result(binding)
    File.write(dest_file, output)
  else
    cp source_file, dest_file
  end
end
