class Book < ApplicationRecord

  belongs_to :user

  # dependent: :destroyは、１のモデルが消えた時にそれと付随してNのモデルも消す処理をするため。
  # 例）ユーザーが退会した時に、そのユーザーの投稿やいいねも一緒に消えるようにする処理
  has_many :favorites,     dependent: :destroy
  has_many :book_comments, dependent: :destroy

  # 今日の投稿数
  scope :created_today,     -> {where(created_at: Time.zone.now.all_day)}
  # 昨日の投稿数
  scope :created_yesterday, -> {where(created_at: 1.day.ago.all_day)}
  # 今週の投稿数
  scope :created_this_week, -> {where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day)}
  # 先週の投稿数
  scope :created_last_week, -> {where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day)}

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
