class SessionsController < ApplicationController

  def new

  end

  def create
    email_input = params[:email].to_s.downcase.strip
    user = User.find_by(email: email_input)

    if user && user.authenticate(params[:password])
      reset_session
      session[:user_id] = user.id
      redirect_to worklogs_url, notice: "Welcome back, #{user.first_name}!"
    else
      unless user
        User.new(password: "placeholder").authenticate('invalid')
      end
      flash.now[:alert] = "Invalid email/password combination!"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to signin_path, status: :see_other, notice: "Signed out!"
  end
end
