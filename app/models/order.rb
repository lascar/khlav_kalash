class Order < ApplicationRecord
  # https://stackoverflow.com/a/38612200/611226 slighly modify
  validates_format_of  :email_address, :with => /\A[\+A-Z0-9\._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}\Z/i
  validates :first_name, :presence => true
  validates :country, :presence => true
  validates :postal_code, :presence => true
  validates :email_address, :presence => true
  validates :quantity, :presence => true

  before_create :set_defaults

  UNIT_PRICE_CENTS = ENV['UNIT_PRICE_CENTS']
  CURRENCY = ENV['CURRENCY']

  def price
    Money.new(UNIT_PRICE_CENTS, CURRENCY)
  end

  private

  def set_defaults
    self.number = next_number
    self.permalink = SecureRandom.hex(20)

    while Order.where(permalink: self.permalink).any?
      self.permalink = SecureRandom.hex(20)
    end
  end

  def next_number
    current = self.class.reorder('number desc').first.try(:number) || '000000000000'
    current.next
  end
end
