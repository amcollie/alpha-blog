class ArticlesController < ApplicationController
  before_action :set_article, only: %w[show edit update destroy]
  before_action :require_user, except: %w[show index]
  before_action :require_same_user, only: %w[edit update destroy]

  def show; end

  def index
    @articles = Article.paginate(page: params[:page], per_page: 5)
  end

  def new
    @article = Article.new
  end

  def edit; end

  def create
    @article = Article.new(article_params)
    @article.user = current_user
    if @article.save
      redirect_to @article, notice: 'Article was created successfully.'
    else
      render 'new'
    end
  end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: 'Article was updated successfully'
    else
      render 'edit'
    end
  end

  def destroy
    @article.destroy
    redirect_to @article
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :description, category_ids: [])
  end

  def require_same_user
    redirect_to @article, alert: 'Can only edit or delete your own articles' if current_user != @article.user &&
                                                                                !current_user.admin?
  end
end
