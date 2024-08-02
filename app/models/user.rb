class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise 를 추가하면 기본적으로 붙음
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # user 와 account 1:1 관계 형성
  has_one :account

  acts_as_token_authenticatable  # 이게 있어야 토큰 갱신됨 Simple Token Authentication 설정

  before_create :ensure_authentication_token # User create 시 토큰 생성

  # user create 시 토큰값이 비어있으면 generate_authentication_token 실행
  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token # 랜덤한 토큰을 생성, 같은 토큰이 없을때 까지
      if User.where(authentication_token: token).first.nil?
        break token
      end
    end
  end


end
