class Book < ApplicationRecord

  belongs_to :user

  # dependent: :destroyは、１のモデルが消えた時にそれと付随してNのモデルも消す処理をするため。
  # 例）ユーザーが退会した時に、そのユーザーの投稿やいいねも一緒に消えるようにする処理
  has_many :favorites,     dependent: :destroy
  has_many :book_comments, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorited_by?(user)
    # Favoriteモデルのuser_idカラムに引数で設定するuserのidが存在するかどうかを判別し、true,falseで返す。
    # .exists?は、存在の判別をするメソッド。
    favorites.where(user_id: user.id).exists?
  end

  def self.search_for(content, method)  # contentは検索ワード
    # 完全一致
    if method == "perfect"
      Book.where(title: content)
    # 前方一致
    elsif method == "forward"
      # モデル名.where("カラム名 LIKE ?", 検索したい文字列 + "%")
      Book.where("title LIKE ?", content + "%")
    # 後方一致
    elsif method == "backward"
      # モデル名.where("カラム名 LIKE ?", "%" + 検索したい文字列)
      Book.where("title LIKE ?", "%" + content)
    # 部分一致
    else
      # モデル名.where("カラム名 LIKE ?", "%" + 検索したい文字列 + "%")
      Book.where("title LIKE ?", "%" + content + "%")
    end
  end

end
