class Player
  BANK = 100

  attr_reader :name, :hand
  attr_accessor :bank

  def initialize(name)
    @name = name
    @bank = BANK
    @hand = Hand.new
  end

  def get_card(card)
    @hand.cards << card
  end

  def remove_cards
    cards_for_deck = []
    cards_for_deck += @hand.cards
    @hand.cards = []
    cards_for_deck
  end

  def open_cards
    @hand.cards.each { |card| card.type = :open }
  end

  def get_prize(amount)
    @bank += amount
  end

  def lose_bet(bet)
    @bank -= bet
    @bank = 0 if bet < 0
  end
end
