require 'securerandom'
class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_user_info

  def index
    @accounts = Account.all
    puts "현재 로그인된 유저 : #{@user.name}"
    render json: {code: 200, data: @accounts}
  end

  def create
    account = Account.where(name: params[:name]).count

    puts "acouunt 확인하기: #{account}"

    if account >= 1
      render json: { code: -1, message: "이미 있는 사용자" }
      return
    end
    # create 방법 찾기
    @account = Account.new
    @account.name = params[:name]
    @account.password = params[:password]
    @account.balance = params[:balance]
    @account.account_num = SecureRandom.alphanumeric(10)

    @account.user = current_user
    @account.save

    render json: {code: 200, message: "계좌생성완료"}
  end

  # 금액 확인
  def confirm_balance
    from_account = Account.select(:balance).find_by(account_num: params[:account_num], password: params[:password])

    if from_account
      @account = Account.find_by(account_num: params[:account_num], password: params[:password])
      puts "계좌 확인 #{from_account.balance}"
    else
      puts "계좌를 찾을 수 없습니다."
      render json: {code: -1, message: "계좌를 찾을 수 없습니다."}
      return
    end

    render json: {code: 200, data: @account}
  end

  # 송금
  def remittance
    @from_account = Account.find_by(account_num: params[:account_num])
    @to_account = Account.find_by(account_num: params[:to_account_num])
    money = params[:money].to_i

    unless @to_account
      puts "입금대상 계좌가 없습니다."
      render json: {code: -1, message: "계좌를 찾을 수 없습니다."}
      return
    end

    if @from_account.balance >= money
      @to_account.balance += money
      @from_account.balance -= money
      puts "송금 계좌 잔액 #{@from_account.balance}"
      puts "입금 계좌 잔액 #{@to_account.balance}"
    else
      puts "잔액이 부족합니다"
      render json: {code: -1, message: "잔액이 부족합니다."}
      return
    end

    @from_account.save
    @to_account.save
    render json: {code: 200, message: "송금 성공"}
  end

  # 입금
  def deposit
    @account = Account.find_by(account_num: params[:account_num])
    money = params[:money].to_i

    if @account.name != @user.name
      puts "본인계좌가 아닙니다."
      render json: {code: -1, message: "계좌의 이름과 일치하지 않습니다."}
      return
    end

    if @account == nil
      puts "입금대상 계좌가 없습니다."
      render json: {code: -1, message: "계좌를 찾을 수 없습니다."}
      return
    end
    puts "입금전 잔액: #{@account.balance}"
    @account.balance += money
    puts "입금후 잔액: #{@account.balance}"

    if @account.save
      render json: {code: 200, message: "입금성공"}
    else
      puts "입금 실패: #{@account.errors.full_messages.join(", ")}"
      render json: { code: -1, message: "입금에 실패했습니다." }
    end


  end

  def destroy
    @account = Account.find(parmas[:id])
    @account.destroy
  end

  def account_param
    params.permit(:id, :name, :password, :account_num, :to_account_num, :money)
  end
end
