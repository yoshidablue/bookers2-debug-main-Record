class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

 # dependent: :destroyは、１のモデルが消えた時にそれと付随してNのモデルも消す処理をするため。
  # 例）ユーザーが退会した時に、そのユーザーの投稿やいいねも一緒に消えるようにする処理
  has_many :books,         dependent: :destroy
  has_many :favorites,     dependent: :destroy
  has_many :book_comments, dependent: :destroy
  # フォローした、されたの関係
  # relationshipsとreverse_of_relationshipsはアソシエーション（例：どれが誰の投稿なのかを関連づけるもの）がつながっているテーブル名
  # class_nameは実際のモデル名前
  # foreign_keyは外部キー（「ここの入れる値は、こっちから選んでいれなさい」な制約（がついている項目））としてなにを持つかを表している
  has_many :relationships,            class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 一覧画面で使う
  # has_many :yyy(テーブル名), through: :xxx(中間テーブル), source: :zzzで、テーブル同士が中間テーブルを通じてつながっていることを表現します。(followerテーブルとfollowedテーブルのつながりを表す)
  # 例）yyyにfollowedを入れると、followedテーブルから中間テーブルを通ってfollowerテーブルにアクセスすることができなくなる。
  # これを防ぐためにyyyには架空のテーブル名を、zzzは実際にデータを取得しにくいテーブル名を書く。
  has_many :followings, through: :relationships,            source: :followed
  has_many :followers,  through: :reverse_of_relationships, source: :follower

  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction,length:{maximum: 50}



  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  # フォローした時の処理
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  # フォローを外す時の処理
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  # フォローしているか判定
  def following?(user)
    followings.include?(user)
  end

  def self.search_for(content, method)  # contentは検索ワード
    # 完全一致
    if method == "perfect"
      User.where(name: content)
    # 前方一致
    elsif method == "forward"
      # モデル名.where("カラム名 LIKE ?", 検索したい文字列 + "%")
      User.where("name LIKE ?", content + "%")
    # 後方一致
    elsif method == "backward"
      # モデル名.where("カラム名 LIKE ?", "%" + 検索したい文字列)
      User.where("name LIKE ?", "%" + content)
    # 部分一致
    else
      # モデル名.where("カラム名 LIKE ?", "%" + 検索したい文字列 + "%")
      User.where("name LIKE ?", "%" + content + "%")
    end
  end

end
