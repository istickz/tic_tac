class Player
  attr_reader :user, :game_symbol

  def initialize(user, game_symbol)
    @user = user
    @game_symbol = game_symbol
  end
end

