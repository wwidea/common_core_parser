require 'rake'
require 'rake/testtask'
require 'rdoc/task'
require 'open-uri'
require 'csv'
require File.expand_path('../lib/common_core_parser', __FILE__)

desc 'Default: run unit tests.'
task :default => :test

desc 'overwrite old files in data folder with latest'
task :update_data_folder do
  ['Math.xml','ELA-Literacy.xml'].each do |filename|
    url = "http://www.corestandards.org/#{filename}"
    open("data/#{filename}", "wb") do |file|
      puts "Pulling: #{url}"
      open(url) do |uri|
         file.write(uri.read)
      end
    end
  end
end

desc 'generate csv standards file'
task :generate_csv_standards_file do
  master = CommonCoreParser::Master.instance
  master.load_elements_from_paths(CommonCoreParser::DATA_PATH+'/**/*.xml')
  CSV.open("standards.csv", "wb") do |csv|
    csv << ['RefID','SubjectGrade','Domain','Cluster','Number/Code','Grades','Text/Statement']
    master.standards.each do |ref_id,standard|
      domain_string = standard.domain.try(:statement) || ''
      domain_string << standard.parent_ref_id if standard.parent_ref_id == 'INTENTIONALLYORPHANED'
      csv << [standard.ref_id,standard.subject.try(:code),domain_string,standard.cluster.try(:statement),standard.code,standard.grades,standard.try(:statement)]
    end
  end
end

desc 'Test the common_core plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the common_core plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'MinimalistAuthentication'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
