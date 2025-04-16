class UsersController < ApplicationController
  include RackSessionFix
  before_action :authenticate_user!
  def index
    if is_superuser?
      @user = User.all
    end
    render json: {
      status: {code: 200, message: 'User list.'},
      data: @user,
      current_user: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
    }, status: :ok
  end

  def show
    @user = User.find_by(id: params[:id])
    if @user
      render json: {
        user: @user,
        status: {code: 200, message: 'User found.'},
      }
    else
      render json: {
        status: {code: 404, message: 'User not found.'}
      }, status: :not_found
    end
  end

  def search_by_email
    email = params[:email]
    @user = User.find_by('LOWER(email) = ?', email.downcase)
    if @user
      render json: {
        status: {code: 200, message: 'User found.'},
        data: @user,
      }, status: :ok
    else
      render json: {
        status: {code: 404, message: 'User not found.'}
      }, status: :not_found
    end
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user
      if is_superuser?
        @user.update(user_params)
        render json: {
          status: {code: 200, message: 'User updated.'},
          data: @user
        }, status: :ok
      else
        render json: {
          status: {code: 403, message: 'You are not authorized to update this user.'}
        }, status: :forbidden
      end
    else
      render json: {
        status: {code: 404, message: 'User not found.'}
      }, status: :not_found
    end
  end

  def destroy
    if is_superuser?
      @user = User.find_by(id: params[:id])
      if @user
        @user.destroy
        render json: {
          status: {code: 200, message: 'User deleted.'}
        }, status: :ok
      else
        render json: {
          status: {code: 404, message: 'User not found.'}
        }, status: :not_found
      end
    else
      render json:{
        status: {code: 403, message: 'You are not authorized to delete this user.'}
      }, status: :forbidden
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password)
  end
end
