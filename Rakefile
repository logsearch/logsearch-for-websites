task :clean do
  rm_rf "target"
  mkdir "target"
end

task :build => :clean do
	puts "===> Building ..."
	sh "vendor/addon-common/bin/build.sh src/parsers/logsearch-for-weblogs.filters.conf.erb > target/logsearch-for-weblogs.filters.conf"
	puts "===> Artifacts:"
	puts `tree target`
end

task :test => :build do
	puts "===> Testing ..."
	sh "vendor/addon-common/bin/test.sh"
end

