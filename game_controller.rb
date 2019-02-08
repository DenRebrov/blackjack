require_relative 'bank.rb'
require_relative 'card.rb'
require_relative 'deck.rb'
require_relative 'player.rb'
require_relative 'dealer.rb'
require_relative 'user.rb'
require_relative 'game_interface.rb'

class GameController
  attr_reader :bank, :deck, :dealer, :user, :interface
  attr_accessor :status

  def initialize(user)
    @deck = Deck.new
    @dealer = Dealer.new
    @bank = Bank.new
    @user = user
    @interface = GameInterface.new(@bank, @deck, @dealer, @user)
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
      @interface.bet
    else
      @interface.judge_info
      judge
    end

    @interface.dealer_cards
    @interface.user_cards
  end

  def user_turn
    input = @interface.user_action

    case input
    when 2
      unless @user.full_hand?
        deal_cards(@user, 1)
        @interface.user_cards
        if @user.score > 21
          @interface.lose_info
          @status = :judge
        end
      end
    when 3
     @interface.judge_info
     judge
    end
  end

  def dealer_turn
    if @status != :judge
      input = @interface.dealer_action

      case input
      when 1
        deal_cards(@dealer, 1)
        @interface.dealer_cards
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

  def judge
    if (@user.score > 21 && @dealer.score <= 21) ||
       (@user.score < @dealer.score &&
        @user.score <= 21 && @dealer.score <= 21)
      @interface.lose_info
      lose
    elsif (@user.score <= 21 && @dealer.score > 21) ||
          (@user.score > @dealer.score &&
          @user.score <= 21 && @dealer.score <= 21)
      @interface.win_info
      win
    else
      @interface.draw_info
      draw
    end
    @status = :judge
  end

  def win
    @user.get_prize(@bank.amount)
  end

  def lose
    @dealer.get_prize(@bank.amount)
  end

  def draw
    @dealer.get_prize(@bank.amount / 2)
    @user.get_prize(@bank.amount / 2)
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

puts 'Игра \"Black Jack\"\n'
puts 'Введите свое имя'
name = gets.chomp
name = 'Аноним' if name.to_s.empty?
user = User.new(name.capitalize)

game = GameController.new(user)
game.run
