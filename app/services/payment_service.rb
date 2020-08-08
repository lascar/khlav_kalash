class PaymentService
  include Rails.application.routes.url_helpers

  def initialize(order:)
    @order = order

    key = Rails.application.secrets.secret_key_base
    @cryptor = ActiveSupport::MessageEncryptor.new(key[0,32], cipher: 'aes-256-gcm')
  end

  def create_session
    secret = gen_secret(@order.num + '_' + @order.permalink)
    amount = @order.quantity * ENV['UNIT_PRICE_CENTS'].to_i

    Stripe::Checkout::Session.create(
      {
        payment_method_types: ['card'],
        line_items: [{
											 name: 'khlav_kalash',
                       description: @order.description,
                       amount: amount,
                       currency: 'eur',
                       quantity: 1,
                     }],
        success_url: order_confirm_url(permalink: @order.permalink, secret: secret),
        cancel_url: order_cancel_url(permalink: @order.permalink),
      })
  end

  def confirm(secret)
    if @cryptor.decrypt_and_verify(secret) == @order.number + '_' + @order.permalink
      # handle a succeed payment
      # send notifications, invoices ... ect
      return true
    else
      return false
    end
  end

  private

	def gen_secret(number_permalink)
		key = Rails.application.secrets.secret_key_base
		@crypt = ActiveSupport::MessageEncryptor.new(key[0,32], cipher: 'aes-256-gcm')
		@crypt.encrypt_and_sign(number_permalink)
	end
end
