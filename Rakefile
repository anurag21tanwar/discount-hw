# frozen_string_literal: true

desc 'check the discounts for the input'
task :run, :input do |_, args|
  file_name = args[:input] || 'input.txt'
  ruby "lib/main.rb seed/#{file_name}"
end

desc 'test the discount logic'
task :test do
  exec('rspec spec/*/*/*_spec.rb')
end
