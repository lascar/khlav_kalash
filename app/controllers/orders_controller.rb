class OrdersController < ApplicationController
  include HttpBasicAuthenticatable

  before_action :http_authenticate, except: [:new, :create, :confirm,
                                             :cancel, :permalink]
  before_action :set_order, only: [:show, :confirm, :cancel, :edit, :update,
                                   :destroy, :permalink]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    if @order.save
      secret = gen_secret(@order.number + '_' + @order.permalink)
      Stripe.api_key = Rails.application.credentials[Rails.env.to_sym][:STRIPE_SECRET_KEY]
      @session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: [{
          price_data: {
            currency: 'eur',
            product_data: {
              name: 'khlav_kalash',
            },
            unit_amount: ENV['UNIT_PRICE_CENTS'],
          },
          quantity: @order.quantity,
        }],
        mode: 'payment',
        success_url: order_confirm_url(permalink: @order.permalink, secret: secret),
        cancel_url: order_cancel_url(permalink: @order.permalink),
      )
    else
      flash[:error] = @order.errors.messages
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /orders/confirm
  def confirm
    secret = gen_secret(@order.number + '_' + @order.permalink)
    if PaymentService.new(order: @order).confirm(secret)
      flash[:success] = "Payment succeed"
    else
      flash[:error] = "Oups Error !"
    end
    redirect_to order_permalink_url(@order, permalink: @order.permalink)
  end

  # GET /orders/cancel
  def cancel
    if @order.permalink == params[:permalink]
      @order.destroy
      respond_to do |format|
        format.html { render :new, notice: 'Order was successfully canceled.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { render :new, notice: 'Order was not canceled.' }
        format.json { head :no_content }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /orders/permalink
  def permalink
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = params[:permalink] ? Order.find_by(permalink: params[:permalink]) :
       Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:quantity, :first_name, :last_name, :street_line_1, :street_line_2, :postal_code, :city, :region, :country, :email_address, :number, :permalink)
    end

    def gen_secret(number_permalink)
      key = Rails.application.secrets.secret_key_base
      @crypt = ActiveSupport::MessageEncryptor.new(key[0,32], cipher: 'aes-256-gcm')
      @crypt.encrypt_and_sign(number_permalink)
    end
end
