class Message < ApplicationRecord
  # belongs_to :recp, :class_name => "User", :foreign_key => :to_id
  # belongs_to :send, :class_name => "User", :foreign_key => :from_id
  
  attr_accessor :to_email

  validates :to_id, presence: true
  validates :from_id, presence: true
  validates :body, presence: true, length: {
    minimum: 1, 
    maximum: 1000,
  }
end
 