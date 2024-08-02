class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user_from_token!, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  acts_as_token_authentication_handler_for User, fallback_to_devise: false

  # Token을 이용하여 유저 특정
  def authenticate_user_from_token!
    user_email = request.headers["X-User-Email"]
    user_token = request.headers["X-User-Token"]
    user = user_email && User.find_by(email: user_email)

    if user && Devise.secure_compare(user.authentication_token, user_token)
      sign_in user, store: false
    else
      render json: {code: -1, message: "로그인을 해주세요"}
    end
  end

  # Devise 의 세션기반 로그인
  # def devise_current_user
  #   @devise_current_user ||= warden.authenticate(scope: :user)
  # end
  #
  # def current_user
  #   devise_current_user
  # end

  # devise 사용 User model에 name column 추가
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def get_user_info
    @user = current_user
    puts "get_user_info 실행 : #{@user.id}"
  end
end
