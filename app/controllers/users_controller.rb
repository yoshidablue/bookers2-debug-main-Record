class UsersController < ApplicationController

  before_action :ensure_correct_user, only: [:edit,:update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new

    # 今日の投稿数
    @today_book = @books.created_today
    # 昨日の投稿数
    @yesterday_book = @books.created_yesterday
    # 今週の投稿数
    @this_week_book = @books.created_this_week
    # 先週の投稿数
    @last_week_book = @books.created_last_week
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
    if @user == current_user
    else
      redirect_to user_path(current_user.id)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  # 指定した日の記録（投稿数）
  def search
    @user = User.find(params[:user_id])
    @books = @user.books
    @book = Book.new
    if params[:created_at] == ""
      @search_book = "日付を選択してください"
    else
      created_at = params[:created_at]
      @search_book = @books.where(['created_at LIKE ? ', "#{created_at}%"]).count
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
