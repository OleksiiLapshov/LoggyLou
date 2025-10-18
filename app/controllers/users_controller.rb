class UsersController < ApplicationController
  before_action :require_signin
  before_action :require_admin, only: [ :index ]
  def index
    @users = User.all
  end

  def show
    if current_user_admin?
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to user_url(@user), notice: "Employee registered!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    if current_user_admin?
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end

  def update
    if current_user_admin?
      @user = User.find(params[:id])
    else
      @user = current_user
    end

    if @user.update(user_params)
      redirect_to @user, notice: "Changes are saved!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email,
                                :password, :password_confirmation,
                                project_ids: [])
  end
end
