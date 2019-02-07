class Card
  attr_reader :name, :score
  attr_accessor :type

  def initialize(name, score, type = :closed)
    @name = name
    @score = score
    @type = type
  end
end
