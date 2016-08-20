require 'mruby/rake/tasks'

desc 'Run the specs'
task :specs do
  Dir['specs/*.spec.rb'].each do |f|
    unless system "mruby #{f}"
      raise "Error running test file: #{f}"
    end
  end
end

desc 'Generate the docs'
task :docs do
  Dir['specs/*.rb'].each do |f|
    sh "mruby #{f} > #{f.sub('specs/', 'docs/').sub('.spec.rb', '.md')}"
  end
end
