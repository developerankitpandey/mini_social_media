class Chat < ApplicationRecord
  belongs_to :sender ,  class_name: 'User'
  belongs_to :receiver,  class_name: 'User'
  has_many :messages, dependent: :destroy

  has_many :user_chats
  has_many :chats, through: :user_chats

  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :recipient, class_name: 'User',  optional: true 
  # foreign_key: 'recipient_id'

end
