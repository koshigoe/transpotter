class FtpAccountsController < ApplicationController
  before_action :authenticate
  before_action :set_ftp_account

  def show
    render json: @ftp_account
  end

  def create
  end

  def put
  end

  private

  def set_ftp_account
    @ftp_account = FtpAccount.find(params[:id])
  end
end
