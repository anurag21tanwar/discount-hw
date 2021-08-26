# frozen_string_literal: true

require_relative '../lib/services/process_data_service'

def main
  File.foreach(ARGV[0]) do |line_data|
    ProcessDataService.new(line_data).call
  end
rescue Errno::ENOENT
  p 'input.txt not found'
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------
main
