# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # where an existing user will authenticate their credentials and it will assign the jwt to the user if successful

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  respond_to :json

  # def create
  #   user = User.find_by_email(sign_in_params[:email])

  #   if user && user.valid_password?(sign_in_params[:password])
  #     token = user.generate_jwt
  #     render json: token.to_json
  #   else
  #     render json: { erros: { 'email or password' => ['is invalid'] } }
  #   end
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private

  def respond_with(resource, _opts = {})
    render json: {
      status: {code: 200, message: 'Logged in successfully.'},
      data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
    }, status: :ok
  end

  def respond_to_on_destroy
    if current_user
      render json: {
        status: 200,
        message: "logged out successfully"
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end
