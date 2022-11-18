class Relationship < ApplicationRecord

  # belongs_to :userとするとどっちがどっちのuserかわからなくなんるので,followerとfollowedで分けている。
  # class_name: "User"でuserテーブルからデータをとってくる
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"


end
