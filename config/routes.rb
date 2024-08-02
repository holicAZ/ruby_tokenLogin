Rails.application.routes.draw do
  # devise users 사용
  # devise sessions controller 대신 해당 url로 호출되면
  # 내가 만든 sessions controller 를 실행
  devise_for :users, controllers: {
    sessions: 'sessions'
  }

  resources :accounts do
    collection do
      post 'deposit' => 'accounts#deposit'
      post 'remittance' =>'accounts#remittance'
    end
  end

  resources :sessions

  # root setting
  root "accounts#index"

end
