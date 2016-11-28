class Api::V1::PinsController < ApplicationController
  before_action :authenticate

  def index
    render json: Pin.all.order('created_at DESC')
  end

  def create
    pin = Pin.new(pin_params)
    if pin.save
      render json: pin, status: 201
    else
      render json: { errors: pin.errors }, status: 422
    end
  end

  private
    def pin_params
      params.require(:pin).permit(:title, :image_url)
    end

  protected
    def authenticate
      authenticate_token || render_unauthorized
    end

    def authenticate_token

        email = request.headers["X-User-Email"]
        token_h = request.headers["X-Api-Token"]
        User.find_by(api_token: token_h, email: email)

    end

    def render_unauthorized
      self.headers['WWW-Authenticate'] = 'Token realm="Pins"'

      # respond_to do |format|
      #   format.json {render json: "Bad credentials", status: 401}
      # end
      head 401
    end
end