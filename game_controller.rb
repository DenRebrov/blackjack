require_relative 'card.rb'
require_relative 'deck.rb'
require_relative 'game_interface.rb'
require_relative 'player.rb'
require_relative 'dealer.rb'
require_relative 'user.rb'

class GameController
  ENTER_NAME = 'Введите свое имя'
  ANONYM = 'Аноним'

  attr_reader :deck, :dealer, :user, :interface

  def initialize
    puts ENTER_NAME
    name = gets.chomp
    name = ANONYM if name == ''

    @deck = Deck.new
    @dealer = Dealer.new
    @user = User.new(name.capitalize)
    @interface = GameInterface.new(@deck, @dealer, @user)
  end

  def distribution
    deal_cards(@user, 2)
    deal_cards(@dealer, 2)
    @user.open_cards
    @dealer.close_cards
  end

  def initial_interface
    if @user.bank > 10 && @dealer.bank > 10
      @interface.bet
    else
      @interface.judge
    end

    @interface.dealer_cards
    @interface.user_cards
  end

  def user_turn
    input = @interface.user_action

    case input
    when 2
      if @user.cards.size == 2
        deal_cards(@user, 1)
        @interface.user_cards
        if @user.sum_score > 21
          @interface.lose
          @interface.status = :judge
        end
      end
    when 3 then @interface.judge
    end
  end

  def dealer_turn
    if @interface.status != :judge
      input = @interface.dealer_action

      case input
      when 1
        deal_cards(@dealer, 1)
        @interface.dealer_cards
      end
    end
  end

  def play_again?
    @interface.get_player_continue
    refresh
  end

  def refresh
    cards = []
    cards += @user.remove_cards
    cards += @dealer.remove_cards
    @deck.add_cards(cards)
  end

  private

  def deal_cards(player, number)
    number.times do |time|
      card = @deck.cards.shuffle.first
      player.get_card(card)
      @deck.remove_card(card)
    end
  end
end

game = GameController.new

while game.interface.status != :finish do
  game.distribution
  game.initial_interface

  while (game.interface.status != :judge) do
    game.user_turn
    game.dealer_turn
  end

  game.play_again?
end
