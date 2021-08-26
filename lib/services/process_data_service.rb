# frozen_string_literal: true

require_relative '../../config/constants'
require_relative '../../lib/services/formatter_service'
require_relative '../../lib/services/calendar_key_service'
require_relative '../../lib/services/discount_service'

# ProcessDataService is used for processing the data line by line
class ProcessDataService
  attr_accessor :data

  @@calendar_month_check, @@max_discount_check, @@l_lp_count_check = [{}, nil, nil]

  def initialize(data)
    @data = data
  end

  def call(std_out = true)
    input_data = FormatterService::InputData.new(data).call
    calendar_key = CalendarKeyService.new(input_data, 'month').call

    unless @@calendar_month_check[calendar_key]
      @@max_discount_check, @@l_lp_count_check = reset_checkers
      @@calendar_month_check[calendar_key] = true
    end

    discount_data, @@max_discount_check, @@l_lp_count_check = DiscountService.new(input_data, @@max_discount_check,
                                                                              @@l_lp_count_check).call
    FormatterService::OutputData.new(input_data, discount_data).call(std_out)
  rescue StandardError
    FormatterService::OutputData.new(input_data, ['Ignored']).call(std_out)
  end

  private

  def reset_checkers
    [MAX_DISCOUNT_PER_MONTH, 0]
  end
end
