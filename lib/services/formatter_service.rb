# frozen_string_literal: true

module FormatterService
  # InputData class could be used for formatting input as per need
  class InputData
    SPLIT_BY = ' '

    attr_accessor :input_data

    def initialize(input_data)
      @input_data = input_data
    end

    def call
      input_data.chomp.split(SPLIT_BY)
    end
  end

  # OutputData class could be used for formatting output as per need
  class OutputData
    JOIN_BY = ' '

    attr_accessor :input_data, :discount_data

    def initialize(input_data, discount_data)
      @input_data = input_data
      @discount_data = discount_data
    end

    def call(std_out = true)
      std_out ? p(output_data) : output_data
    end

    private

    def output_data
      (input_data + format_discount_data).join(JOIN_BY)
    end

    def format_discount_data
      discount_data.map do |data|
        data.is_a?(Float) ? format_float(data) : data
      end
    end

    def format_float(data)
      format('%.2f', data)
    end
  end
end
