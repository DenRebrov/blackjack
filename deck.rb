class Deck
  attr_accessor :cards

  def initialize
    @cards = []

    counter = 2
    52.times.each do |time|
      case counter
      when 11
        card_name = "J"
        card_score = 10
      when 12
        card_name = "Q"
        card_score = 10
      when 13
        card_name = "K"
        card_score = 10
      when 14
        card_name = "A"
        card_score = [1, 11]
      else
        card_name = "#{counter}"
        card_score = counter
      end

      if time.between?(13, 25)
        card_symbol = "<>"
      elsif time.between?(26, 38)
        card_symbol = "+"
      elsif time > 38
        card_symbol = "<3"
      else
        card_symbol = "^"
      end

      counter += 1
      counter = 2 if counter > 14

      @cards << Card.new("#{card_name} #{card_symbol}", card_score)
    end
  end

  def shuffle
    @cards.shuffle
  end

  def remove_card(card)
    @cards.delete(card)
  end

  def add_cards(cards)
    @cards += cards
  end
end
