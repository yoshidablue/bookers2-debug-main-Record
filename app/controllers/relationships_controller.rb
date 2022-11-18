class RelationshipsController < ApplicationController

  # フォローする時
  def create
    current_user.follow(params[:user_id])
    # 遷移元のURLにリダイレクトする
    redirect_to request.referer
  end

  # フォロー外す時
  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end

  # フォロー一覧
  def followings
    user = User.find(params[:user_id])
    @users = user.followings
  end

  # フォロワー一覧
  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end

end
