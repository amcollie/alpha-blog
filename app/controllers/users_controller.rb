class UsersController < ApplicationController
  before_action :set_user, only: %w[show edit update]
  before_action :require_user, only: %w[edit update]
  before_action :require_same_user, only: %w[edit update]

  def show
    @articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to articles_path, notice: "Welcome #{@user.username}, you have successfully logged ."
    else
      render 'new'
    end
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "#{@user.username} was successfully updated"
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    redirect_to @user, alert: 'Can only edit your own profile' if current_user != @user
  end
end
