class ApplicationController < ActionController::API
  before_action :set_content_type
  before_action :validate_version
  before_action :validate_data_type

  SUPPORTED_VERSIONS = %w(1.0).freeze

  rescue_from ActionController::ParameterMissing do |e|
    render status: 400, json: { errors: [{ title: 'required parameter missing', status: 400 }] }
  end

  private

  def set_content_type
    response.headers['Content-Type'] = 'application/vnd.api+json'
  end

  def validate_version
    return if SUPPORTED_VERSIONS.include?(params[:version])

    render json: { errors: [{ id: 'version_check', status: 400 }] }, status: :bad_request
  end

  def validate_data_type
    return if params.require(:data).require(:type) == controller_name.pluralize
    render json: { errors: [{ title: 'Invalid type', status: 400 }] }, status: 400
  end
end
