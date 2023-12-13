class UsersController < ApplicationController
  def login
  end

  def process_login
    user = User.fetch_user(user_login_params[:email])

    if user && User.authenticate_password(user['password'], user_login_params[:password])
      session[:user] = user
      redirect_to '/blogs'
    else
      flash[:notice] = 'Users not found/Wrong Password'
      redirect_to '/login'
    end 
  end

  def registration
  end

  def process_register
    validations = User.validate_registration(user_register_params)

    if validations.empty?
      user = User.register_user(user_register_params)
      flash[:notice] = 'Registered User' if user.present?
      redirect_to '/login'
    else
      flash[:notice] = validations.join(', ')
      redirect_to '/registration'
    end 
  end

  private

  def user_register_params
    params.require(:register).permit(:first_name, :last_name, :email, :password, :confirm_password)
  end 

  def user_login_params
    params.require(:login).permit(:email, :password)
  end
end
