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

