class User < ActiveRecord::Base
  has_many :user_activities
  has_many :activities, through: :user_activities
end
