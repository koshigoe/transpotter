class FTPAccountsController < ApplicationController
  before_action :authenticate
  before_action :validate_data_type, only: [:create, :update, :destroy]
  before_action :set_ftp_account, only: [:show, :update]

  def show
    render json: @ftp_account
  end

  def create
    ftp_account = FTPAccount.create!(
      password: create_params[:password],
      uid: Rails.configuration.x.proftpd_account.default_uid,
      gid: Rails.configuration.x.proftpd_account.default_gid,
      homedir: Rails.configuration.x.proftpd_account.default_homedir,
    )
    render json: ftp_account
  end

  def update
    @ftp_account.update!(password: update_params[:password])
    render json: @ftp_account
  end

  def destroy
    FTPAccount.find_by(id: params.require(:data).require(:id))&.destroy
    render json: { data: nil }
  end

  private

  def set_ftp_account
    @ftp_account = FTPAccount.find(params[:id])
  end

  def create_params
    params.require(:data).require(:attributes).permit(:password)
  end

  def update_params
    params.require(:data).require(:attributes).permit(:password)
  end
end
