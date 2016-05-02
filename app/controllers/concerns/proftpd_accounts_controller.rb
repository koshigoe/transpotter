module ProFTPDAccountsController
  extend ActiveSupport::Concern

  included do
    before_action :authenticate
    before_action :validate_data_type, only: [:create, :update, :destroy]
    before_action :set_account, only: [:show, :update]

    def show
      render json: @account
    end

    def create
      account = resource_class.create!(
        password: create_params[:password],
        uid: Rails.configuration.x.proftpd_account.default_uid,
        gid: Rails.configuration.x.proftpd_account.default_gid,
        homedir: Rails.configuration.x.proftpd_account.default_homedir,
      )
      render json: account
    end

    def update
      @account.update!(password: update_params[:password])
      render json: @account
    end

    def destroy
      resource_class.find_by(id: params.require(:data).require(:id))&.destroy
      render json: { data: nil }
    end

    private

    def resource_class
      @resource_class ||= controller_name.classify.constantize
    end

    def set_account
      @account = resource_class.find(params[:id])
    end

    def create_params
      params.require(:data).require(:attributes).permit(:password)
    end

    def update_params
      params.require(:data).require(:attributes).permit(:password)
    end
  end
end
