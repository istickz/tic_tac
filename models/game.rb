class Game < ActiveRecord::Base
  has_many :game_results
  has_many :users, through: :game_results
  before_create :build_board


  def player1
    Player.new(users.first, '❌')
  end

  def player2
    Player.new(users.second, '⭕')
  end

  def players
    [player1, player2]
  end

  def board
    Board.new(data['board'])
  end

  def new?
    board.new?
  end

  def full?
    board.full?
  end

  def make_move(player, index)
    if next_player.user == player
      board.place_symbol(index, next_player.game_symbol)
      self.data['board'] = board.cells
      self.data_will_change!
      self.save
      if winner_player
        "Winner: #{winner_player.user.username}"
      else
        "Next move #{next_player.user.try(:username)}"
      end
    else
      "#{next_player.user ? next_player.user.username : 'Another Player is'} waiting"
    end
  end

  def ended?
    winner_player.present?
  end

  def status
    return 'Board is full' if full?
    return 'Waiting for Players' if new?

    if winner_player
      "Winner: #{winner_player.user.username}"
    elsif full?
      'Game is Tie'
    else
      next_player.user.present? ? "Next move #{next_player.user.username}" : 'Waiting next player'
    end
  end

  def winner_player
    win_symbol = nil
    WINNING_COMBOS.each do |combo|
      strategy = combo.map {|index| board.cells[index]}
      uniq_symbols = strategy.uniq
      if uniq_symbols.size == 1 && !uniq_symbols.include?(' ')
        win_symbol = uniq_symbols.first
        break
      end
    end
    if win_symbol
      player = player1.game_symbol == win_symbol ? player1 : player2
      result = player.user.game_results.find_by(game_id: id)
      result.update_columns(winner: true)
      player
    end
  end

  def next_player
    return player1 if new?
    player1_moves = board.cells.count {|cell| cell == player1.game_symbol}
    player2_moves = board.cells.count {|cell| cell == player2.game_symbol}
    return player1 if player1_moves <= player2_moves
    if player1_moves <= player2_moves
      player1
    else
      player2
    end
  end

  def pretend_player(user)
    users_count = users.count
    game_user = users.find_by(id: user.id)
    return user if game_user
    self.users << user if users_count < 3
    user
  end

  private

  WINNING_COMBOS = [
    [0, 1, 2], [3, 4, 5],
    [6, 7, 8], [0, 3, 6],
    [1, 4, 7], [2, 5, 8],
    [0, 4, 8], [2, 4, 6]
  ]

  def build_board
    self.data[:board] = Board.new([' ']*9).cells
  end
end