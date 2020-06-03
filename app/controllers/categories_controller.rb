class CategoriesController < ApplicationController
  before_action :set_category, only: %w[show edit update]
  before_action :require_admin, except: %w[index show]
  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to @category, notice: 'Category was successfully created'
    else
      render 'new'
    end
  end

  def edit; end

  def update
    if @category.update(category_params)
      redirect_to category_path(@category), notice: 'Catgory name was successfully updated'
    else
      render 'edit'
    end
  end

  def index
    @categories = Category.paginate(page: params[:page], per_page: 5)
  end

  def show
    @category_articles = @category.articles.paginate(page: params[:page], per_page: 5)
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def set_category
    @category = Category.find(params[:id])
  end

  def require_admin
    redirect_to categories_path, alert: 'Only admins can perform that action' unless logged_in? && current_user.admin?
  end
end
