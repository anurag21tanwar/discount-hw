# frozen_string_literal: true

require_relative '../../config/constants'

# DiscountService class is used for calculating discount of a transaction as per various condition like:
# 1) All S shipments should always match the lowest S package price among the providers.
# 2) Third L shipment via LP should be free, but only once a calendar month.
# 3) Accumulated discounts cannot exceed 10 EURO in a calendar month. If there are not enough funds to fully cover a
# discount this calendar month, it should be covered partially.
class DiscountService
  attr_accessor :package_code, :carrier_code, :max_discount, :l_lp_count, :price

  def initialize(args, max_discount, l_lp_count)
    @package_code = args[1]
    @carrier_code = args[2]
    @max_discount = max_discount
    @l_lp_count = l_lp_count
  end

  def call
    raise 'Invalid package or carrier' unless check_package_and_carrier

    @price = package_and_carrier_price
    discount_by_package
  end

  private

  def check_package_and_carrier
    PRICES.key?(package_code) && PRICES[package_code].key?(carrier_code)
  end

  def package_and_carrier_price
    PRICES[package_code][carrier_code]
  end

  def discount_by_package
    case package_code
    when 'S'
      discount_for_package_s
    when 'L'
      discount_for_package_l
    else
      result(no_discount)
    end
  end

  def discount_for_package_s
    discount = price - MIN_S_PRICE

    if max_discount > discount
      @max_discount = max_discount - discount
      result([MIN_S_PRICE, discount.zero? ? '-' : discount])
    elsif max_discount.positive?
      discount = max_discount
      @max_discount = 0
      result([price - discount, discount])
    else
      result
    end
  end

  def discount_for_package_l
    return result(no_discount) unless carrier_code == 'LP'

    @l_lp_count = l_lp_count + 1

    if l_lp_count != WHICH_L_LP_FREE
      result
    else
      @max_discount = max_discount - price
      result(free_shipment)
    end
  end

  def result(discount_data = nil)
    discount_data ||= no_discount
    [discount_data, max_discount, l_lp_count]
  end

  def no_discount
    [price, '-']
  end

  def free_shipment
    [0.0, price]
  end
end
