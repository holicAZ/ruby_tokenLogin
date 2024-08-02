class SessionsController < Devise::SessionsController
  # Devise 의 SessionsController 를 상속
  def create
    # super do => 부모가 되는 Devise::SessionController 를 똑같이 상속받아 실행하며
    # 아래 추가로 작성한 코드도 실행하도록 함.
    super do |user|
      #if user&.valid_password?(params[:password])
      # user token 갱신
      if user
        user.update(authentication_token: "")
        render json: {code:200, message:"유저 토큰 완료"}
      else
        render json: {code:-1, message:"유저가 없습니다"}
      end
      return
    end
  end


  def session_params
    params.permit(:email, :password)
  end
end
