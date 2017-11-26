class MessageResponder
  attr_reader :message
  attr_reader :bot
  attr_reader :user

  def initialize(options)
    @bot = options[:bot]
    @message = options[:message]

    @user = User.where(uid: message.from.id).first_or_create
    attributes = message.from.attributes
    attributes.delete(:id)
    @user.update_attributes(attributes)
  end

  def respond
    case message
      when Telegram::Bot::Types::InlineQuery
        options = [
          Telegram::Bot::Types::InlineQueryResultArticle.new(
            id: 1,
            title: 'TicTacToe new game',
            input_message_content: Telegram::Bot::Types::InputTextMessageContent.new(message_text: 'Игра начинается.'),
            reply_markup: TelegramBoard.build
          )
        ]

        bot.api.answer_inline_query(inline_query_id: message.id, results: options)
      when Telegram::Bot::Types::CallbackQuery
        case message.data
          when /^tic_tac_pos_/
            game = Game.where(inline_message_id: message.inline_message_id, chat_instance: message.chat_instance).first_or_create

            if game.pretend_player(user) && !game.ended?
              position = message.data.gsub('tic_tac_pos_', '').to_i
              game.make_move(user, position)

              bot.api.edit_message_text(
                inline_message_id: message.inline_message_id,
                text:  game.status,
                reply_markup: TelegramBoard.build(game.data['board'])
              )
            else
              byebug
              bot.api.answer_callback_query(
                callback_query_id: message.id
              )
            end
        end

      when Telegram::Bot::Types::Message
        on /^\/start/ do
          bot.api.send_message(chat_id: message.chat.id, text: I18n.t('greeting_message'))
        end
    end
  end


  private

  def on regex, &block
    regex =~ message.text

    if $~
      case block.arity
        when 0
          yield
        when 1
          yield $1
        when 2
          yield $1, $2
      end
    end
  end
end
