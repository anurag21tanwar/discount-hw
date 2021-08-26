# frozen_string_literal: true

require 'date'

# CalendarKeyService is used for finding the calendar month from a transaction date
class CalendarKeyService
  attr_accessor :date, :key

  def initialize(args, key)
    @date = args[0]
    @key = key
  end

  def call
    d = Date.parse(date)
    send("#{key}ly", d)
  end

  private

  def monthly(d)
    "#{d.year}-#{d.month}"
  end

  def yearly(d)
    "#{d.year}"
  end
end
