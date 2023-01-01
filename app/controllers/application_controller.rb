class ApplicationController < ActionController::API
    # process a jwt when a user sends a request to the API
    # checks for a valid jwt
    # tutorial: https://dev.to/dhintz89/devise-and-jwt-in-rails-2mlj

    # respond_to :json
    # before_action :process_token
    before_action :configure_permitted_parameters, if: :devise_controller?

    # private 

    # def authenticate_user!(options = {})
    #     head :unauthorized unless signed_in?
    # end

    # def signed_in?
    #     @current_user_id.present?
    # end

    # def current_user
    #     @current_user ||= super || User.find(@current_user_id)
    # end

    # def process_token
    #     if request.headers['Authorization'].present?
    #         begin
    #             jwt_payload = JWT.decode(
    #                 request.headers['Authorization'].split(' ')[1], 
    #                 Rails.application.secrets.secret_key_base).first

    #             @current_user_id = jwt_payload['id']
    #         rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
    #             head :unauthorized
    #         end
    #     end
    # end
    
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_in, keys: [:login])
        devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
    end
end
