class GameInterface
  INTRO = 'Игра \"Black Jack\"\n'
  ENTER_NAME = 'Для начала введите свое имя'
  ANONIM = 'Аноним'
  DEALER = 'Крупье '
  USER = 'Игрок '
  SHIRT = '* '
  COMMA = ', '
  SUM_SCORES = 'Сумма очков: '
  BETS = 'Ставки сделаны: '
  YOUR_ACTIONS = 'Ваши действия:'
  LOSE = 'Вы проиграли ((('
  WIN = 'ПОБЕДА!!!'
  DRAW = 'Ничья...'
  PLAY_AGAIN =  'Хотите сыграть снова?'
  DEALER_SCORES = 'Очки крупье: '

  USER_CHOICES = %i[Да Нет].freeze

  DEALER_ACTIONS = [
    'Крупье пропускает ход...',
    'Крупье берет карту',
    'Крупье открывает карты...'
    ].freeze

  ACTIONS = [
    'Пропустить ход',
    'Добавить карту',
    'Открыть карты'
    ].freeze

  attr_reader :user_name

  def initialize
    @user_name = create_name
  end

  def create_name
    puts INTRO
    puts ENTER_NAME
    name = gets.chomp
    name = ANONIM if name.to_s.empty?
    name
  end

  def dealer_cards(dealer)
    puts DEALER + "(#{dealer.bank} $)"

    dealer.hand.cards.each do |card|
      if card.type == :closed
        print SHIRT
      else
        print card.rank + card.suit + COMMA
      end
    end
    puts
    puts
  end

  def user_cards(user)
    puts USER + "#{user.name} (#{user.bank} $)"

    user.hand.cards.each do |card|
      print card.rank + card.suit + COMMA
    end
    puts SUM_SCORES + "#{user.hand.score}"
    puts
  end

  def bet(bank, user, dealer)
    bank.bet(user, dealer)
    puts BETS + "#{bank.amount} $"
    puts
  end

  def user_action
    puts YOUR_ACTIONS
    input = select_choice(ACTIONS)
  end

  def dealer_action(dealer)
    if dealer.hand.score >= 17
      puts DEALER_ACTIONS[0]
      input = 0
    else
      puts DEALER_ACTIONS[1]
      input = 1
    end
    delay
    input
  end

  def get_player_continue
    puts PLAY_AGAIN
    input = select_choice(USER_CHOICES)
  end

  def open_cards_info(dealer)
    puts DEALER_ACTIONS[2]
    dealer.open_cards
    dealer_cards(dealer)
    delay
    puts DEALER_SCORES + "#{dealer.hand.score}"
    delay
  end

  def lose_info
    puts LOSE
    delay
  end

  def win_info
    puts WIN
    delay
  end

  def draw_info
    puts DRAW
    delay
  end

  private

  def select_choice(array)
    array.each.with_index(1) do |action, index|
      puts "#{index}. #{action}"
    end
    input = gets.to_i
    input = gets.to_i until input.between?(1, array.size)
    input
  end

  def delay
    sleep 1
  end
end
