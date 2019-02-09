require_relative 'bank.rb'
require_relative 'card.rb'
require_relative 'deck.rb'
require_relative 'player.rb'
require_relative 'dealer.rb'
require_relative 'user.rb'
require_relative 'hand.rb'
require_relative 'game_interface.rb'

class GameController
  attr_reader :bank, :deck, :dealer, :user, :interface
  attr_accessor :status

  def initialize
    @deck = Deck.new
    @dealer = Dealer.new
    @bank = Bank.new
    @interface = GameInterface.new
    @user = User.new(@interface.user_name.capitalize)
    @status = :in_progress
  end

  def run
    while (@status != :finish) do
      if have_money?
        distribution
        initial_interface
      else
        @interface.lose_info
        break
      end

      while (@status != :judge) do
        user_turn
        dealer_turn
      end

      play_again?
    end
  end

  private

  def distribution
    deal_cards(@user, 2)
    deal_cards(@dealer, 2)
    @user.open_cards
    @dealer.close_cards
  end

  def initial_interface
    if @user.bank > 10 && @dealer.bank > 10
      @interface.bet(@bank, @user, @dealer)
    else
      @interface.open_cards_info(@dealer)
      define_winner
    end

    @interface.dealer_cards(@dealer)
    @interface.user_cards(@user)
  end

  def user_turn
    input = @interface.user_action

    case input
    when 2
      unless @user.hand.full?
        deal_cards(@user, 1)
        @interface.user_cards(@user)
        if @user.hand.score > 21
          @interface.lose_info
          @status = :judge
        end
      end
    when 3
      @interface.open_cards_info(@dealer)
      define_winner
    end
  end

  def dealer_turn
    if @status != :judge
      input = @interface.dealer_action(@dealer)

      case input
      when 1
        deal_cards(@dealer, 1)
        @interface.dealer_cards(@dealer)
      end
    end
  end

  def play_again?
    input = @interface.get_player_continue
    input == 2 ? @status = :finish : @status = :in_progress
    refresh
  end

  def have_money?
    true unless @bank.zero?(@user)
  end

  def define_winner
    @status = :judge
    return @interface.draw_info + @bank.draw(@user, @dealer) if @user.hand.score > 21 && @dealer.hand.score > 21
    return @interface.draw_info + @bank.draw(@user, @dealer) if @user.hand.score == @dealer.hand.score
    return @interface.lose_info + @bank.lose(@dealer) if @user.hand.score > 21
    return @interface.win_info + @bank.win(@user) if @dealer.hand.score > 21

    if @user.hand.score > @dealer.hand.score
      return @interface.win_info + @bank.win(@user)
    else
      return @interface.lose_info + @bank.lose(@dealer)
    end
  end

  def refresh
    cards = []
    cards += @user.remove_cards
    cards += @dealer.remove_cards
    @deck.add_cards(cards)
  end

  def deal_cards(player, number)
    number.times do |time|
      card = @deck.cards.first
      player.get_card(card)
      @deck.remove_card(card)
    end
  end
end

game = GameController.new
game.run
