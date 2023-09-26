class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy 
  has_one_attached :image 

  def liked_by?(user)
    likes.exists?(user: user)
  end

  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "id", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["comments", "image_attachment", "image_blob", "likes", "user"]
  end
end
