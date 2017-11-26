class User < ActiveRecord::Base
  has_many :game_results
  has_many :games, through: :game_results
end
