class Player
  BANK = 100

  attr_reader :name, :cards
  attr_accessor :bank

  def initialize(name)
    @name = name
    @bank = BANK
    @cards = []
  end

  def get_card(card)
    @cards << card
  end

  def remove_cards
    cards_for_deck = []
    cards_for_deck += @cards
    @cards = []
    cards_for_deck
  end

  def open_cards
    @cards.each { |card| card.type = :open }
  end

  def sum_score
    sum ||= 0
    @cards.each do |card|
      if card.score.is_a?(Array)
        if sum + 11 > 21
          sum += card.score[0]
        else
          sum += card.score[1]
        end
      else
        sum += card.score
      end
    end
    sum
  end

  def get_prize(bet)
    @bank += bet * 2
  end

  def get_bet(bet)
    @bank += bet
  end

  def lose_bet(bet)
    @bank -= bet
    @bank = 0 if bet < 0
  end
end
