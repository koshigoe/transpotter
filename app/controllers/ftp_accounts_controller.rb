class FtpAccountsController < ApplicationController
  before_action :authenticate
  before_action :validate_data_type, only: [:create]
  before_action :set_ftp_account, only: [:show]

  def show
    render json: @ftp_account
  end

  def create
    ftp_account = FtpAccount.create!(
      password: create_params[:password],
      uid: Rails.configuration.x.ftp_account.default_uid,
      gid: Rails.configuration.x.ftp_account.default_gid,
      homedir: Rails.configuration.x.ftp_account.default_homedir,
    )
    render json: ftp_account
  end

  def put
  end

  private

  def set_ftp_account
    @ftp_account = FtpAccount.find(params[:id])
  end

  def create_params
    params.require(:data).require(:attributes).permit(:password)
  end
end
