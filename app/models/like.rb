class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "post_id", "updated_at", "user_id"]
  end
end
