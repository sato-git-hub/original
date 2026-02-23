class DepositsController < ApplicationController

  def new 
    @deposit = Deposit.new
  end

  def create
    @deposit = current_user.build_deposit(deposit_params)

    if @deposit.save
        redirect_to current_user, notice: "処理に成功しました"
    else
      flash.now[:alert] = "処理に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @deposit = current_user.deposit
  end

  def update
    @deposit = current_user.deposit

    if @deposit.update(deposit_params)
        redirect_to current_user, notice: "処理に成功しました"
    else
      flash.now[:alert] = "処理に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def deposit_params
    params.require(:deposit).permit(:bank_name, :account_number, :account_holder, :branch_name, :radio_group)
  end

end
