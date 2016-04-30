class AuthenticationsController < ApplicationController
  def create
    if user = User.find_by(username: create_params[:username])&.authenticate(create_params[:password])
      render json: user, serializer: AuthenticationSerializer
    else
      render json: { errors: [{ title: 'Incorrect username or password', status: 401 }] }, status: 401
    end
  end

  private

  def create_params
    params.require(:data).require(:attributes).permit(:username, :password)
  end
end
