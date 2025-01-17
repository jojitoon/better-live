class User < ApplicationRecord
  require 'securerandom'
  has_secure_password
  has_many :bets
  has_many :games

  validates :email, presence: true, uniqueness: true

end
