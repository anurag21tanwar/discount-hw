# frozen_string_literal: true

PRICES = {
  'S' => {
    'LP' => 1.5,
    'MR' => 2.0
  },
  'M' => {
    'LP' => 4.9,
    'MR' => 3.0
  },
  'L' => {
    'LP' => 6.9,
    'MR' => 4.0
  }
}.freeze

MAX_DISCOUNT_PER_MONTH = 10.0
MIN_S_PRICE = PRICES['S'].values.min
WHICH_L_LP_FREE = 3
