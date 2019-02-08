class GameInterface
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

  def initialize(bank, deck, dealer, user)
    @bank = bank
    @deck = deck
    @dealer = dealer
    @user = user
  end

  def create_name

  end

  def dealer_cards
    puts DEALER + "(#{@dealer.bank} $)"

    @dealer.cards.each do |card|
      if card.type == :closed
        print SHIRT
      else
        print card.rank + card.suit + COMMA
      end
    end
    puts
    puts
  end

  def user_cards
    puts USER + "#{@user.name} (#{@user.bank} $)"

    @user.cards.each do |card|
      print card.rank + card.suit + COMMA
    end
    puts SUM_SCORES + "#{@user.score}"
    puts
  end

  def bet
    @bank.bet(@user, @dealer)
    puts BETS + "#{@bank.amount} $"
    puts
  end

  def user_action
    puts YOUR_ACTIONS
    input = select_choice(ACTIONS)
  end

  def dealer_action
    if @dealer.score >= 17
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

  def judge_info
    puts DEALER_ACTIONS[2]
    delay
    @dealer.open_cards
    dealer_cards
    puts DEALER_SCORES + "#{@dealer.score}"
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
