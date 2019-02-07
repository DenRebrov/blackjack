class GameInterface
  BET = 10

  DEALER = 'Крупье '
  USER = 'Игрок '
  SHIRT = '* '
  COMMA = ', '
  SUM_SCORES = 'Сумма очков: '
  BETS = 'Ставки: '
  YOUR_ACTIONS = 'Ваши действия'
  LOSE = 'Вы проиграли ((('
  WIN = 'ПОБЕДА!!!'
  DRAW = 'Ничья...'
  PLAY_AGAIN =  'Хотите сыграть снова?'
  DEALER_SCORES = 'Очки кррупье'

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

  attr_accessor :status

  def initialize(deck, dealer, user)
    @deck = deck
    @dealer = dealer
    @user = user
    @status = :in_progress
  end

  def dealer_cards
    puts DEALER + "(#{@dealer.bank} $)"

    @dealer.cards.each do |card|
      if card.type == :closed
        print SHIRT
      else
        print card.name + COMMA
      end
    end
    puts
    puts
  end

  def user_cards
    puts USER + "#{@user.name} (#{@user.bank} $)"

    @user.cards.each do |card|
      print card.name + COMMA
    end
    puts SUM_SCORES + "#{@user.sum_score}"
    puts
  end

  def bet
    puts BETS + "#{BET * 2}"
    @user.lose_bet(BET)
    @dealer.lose_bet(BET)
    puts
  end

  def user_action
    puts YOUR_ACTIONS
    input = select_choice(ACTIONS)
  end

  def dealer_action
    if @dealer.sum_score >= 17
      puts DEALER_ACTIONS[0]
      input = 0
    else
      puts DEALER_ACTIONS[1]
      input = 1
    end
    sleep 1
    input
  end

  def lose
    puts LOSE
    @dealer.get_prize(BET)
  end

  def win
    puts WIN
    @user.get_prize(BET)
  end

  def draw
    puts DRAW
    @dealer.get_bet(BET)
    @user.get_bet(BET)
  end

  def get_player_continue
    puts PLAY_AGAIN

    input = select_choice(USER_CHOICES)
    input == 2 ? @status = :finish : @status = :in_progress
  end

  def judge
    puts DEALER_ACTIONS[2]
    sleep 1
    @dealer.open_cards
    dealer_cards
    puts DEALER_SCORES + "#{@dealer.sum_score}"

    if (@user.sum_score > 21 && @dealer.sum_score <= 21) ||
        (@user.sum_score < @dealer.sum_score &&
        @user.sum_score <= 21 && @dealer.sum_score <= 21) ||
        (@user.bank < BET)
      lose
    elsif (@user.sum_score <= 21 && @dealer.sum_score > 21) ||
        (@user.sum_score > @dealer.sum_score &&
        @user.sum_score <= 21 && @dealer.sum_score <= 21) ||
        (@dealer.bank < BET)
      win
    else
      draw
    end
    @status = :judge
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

end
