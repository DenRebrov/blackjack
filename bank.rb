class Bank
  BET = 10

  attr_reader :amount

  def initialize
    @amount = 0
  end

  def bet(player, dealer)
    player.lose_bet(BET)
    dealer.lose_bet(BET)
    @amount = BET * 2
  end

  def zero?(player)
    player.bank < BET
  end

  def reward_winner(player)
    player.get_prize(@amount)
    @amount = 0
  end

  def draw(user, dealer)
    dealer.get_prize(@amount / 2)
    user.get_prize(@amount / 2)
    @amount = 0
  end

  def can_make_bet?(player)
    player.bank >= BET
  end
end
