class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :set_content_type
  before_action :validate_version

  SUPPORTED_VERSIONS = %w(1.0).freeze
  REALM = 'Application'.freeze

  rescue_from ActionController::ParameterMissing do |e|
    render status: 400, json: { errors: [{ title: 'required parameter missing', status: 400 }] }
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render status: 404, json: { errors: [{ title: "#{controller_name.singularize.humanize} not found", status: 404 }] }
  end

  def current_user
    @current_user
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
    return if params.require(:data).require(:type) == controller_name.singularize
    render json: { errors: [{ title: 'Invalid type', status: 400 }] }, status: 400
  end

  def authenticate
    return if @current_user = authenticate_with_http_token { |token, _| User.authenticate_by_token(token) }

    response.headers["WWW-Authenticate"] = %(Token realm="#{REALM.gsub(/"/, "")}")
    render json: { errors: [{title: 'HTTP Token: Access denied', status: 401 }] }, status: 401
  end
end
