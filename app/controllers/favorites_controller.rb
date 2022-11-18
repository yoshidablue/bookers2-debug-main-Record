class FavoritesController < ApplicationController

  def create
    @book = Book.find(params[:book_id])
    # favorite = Favorites.new(book_id: book_id)
    # 上のローカル変数bookで定義したBookモデルのデータのidをbook_idカラムに代入し、そのFavoriteモデルのデータが新しく作成され、それがローカル変数favoriteに代入している。
    # favorite.user_id = current_user.id
    # 新しく作成されたFavoriteモデルのデータのuser_idは現在のユーザーのidとしている。
    # 上記の簡略化が下記
    favorite = current_user.favorites.new(book_id: @book.id)
    favorite.save
    # 遷移元のURLにリダイレクトする
    # 非同期通信で不要
    # redirect_to request.referer
  end

  def destroy
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by(book_id: @book.id)
    favorite.destroy
    # 遷移元のURLにリダイレクトする
    # 非同期通信で不要
    # redirect_to request.referer
  end

end
