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
    @status = :in_progress
  end

  def run
    @user = User.new(@interface.user_name.capitalize)

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
    if @bank.can_make_bet?(@user) && @bank.can_make_bet?(@dealer)
      bet
      @interface.bet_info(@bank)
    else
      @interface.open_cards_info(@dealer)
      judge
    end

    @interface.dealer_cards(@dealer)
    @interface.user_cards(@user)
  end

  def bet
    @bank.bet(@user, @dealer)
  end

  def user_turn
    input = @interface.user_action

    case input
    when 2
      unless @user.hand.full?
        deal_cards(@user, 1)
        @interface.user_cards(@user)
        if @user.hand.score > Hand::MAX_SCORE
          @interface.lose_info
          @status = :judge
        end
      end
    when 3
      @interface.open_cards_info(@dealer)
      judge
    end
  end

  def dealer_turn
    if @status != :judge
      if @dealer.hand.score >= 17
        @interface.dealer_skips(@dealer)
      else
        @interface.dealer_takes_card(@dealer)
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
    return if @user.hand.score > Hand::MAX_SCORE && @dealer.hand.score > Hand::MAX_SCORE
    return if @user.hand.score == @dealer.hand.score
    return Dealer if @user.hand.score > Hand::MAX_SCORE
    return User if @dealer.hand.score > Hand::MAX_SCORE

    [@user, @dealer].max_by { |player| player.hand.score }
  end

  def judge
    winner = define_winner
    @status = :judge
    case winner
    when User
      @interface.win_info
      @bank.reward_winner(@user)
    when Dealer
      @interface.lose_info
      @bank.reward_winner(@dealer)
    else
      @interface.draw_info
      @bank.draw(@user, @dealer)
    end
  end

  def refresh
    @user.refresh_cards
    @dealer.refresh_cards
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
