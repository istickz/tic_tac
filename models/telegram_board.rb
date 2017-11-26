class TelegramBoard
  def self.build(cells=[' ']*9)
    index = 0
    kb = cells.each_slice(3).map do |row|
      res = []
      row.each do |cell|
        res << Telegram::Bot::Types::InlineKeyboardButton.new(text: cell, callback_data: "tic_tac_pos_#{index}")
        index += 1
      end
      res
    end
    Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
  end
end
