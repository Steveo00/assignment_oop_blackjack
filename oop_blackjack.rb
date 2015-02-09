module Hand
  def hand_total(cards)
    values = cards.map { |card| card.value }
  
    hand_total = 0
    values.each do | val |
      if val == "Ace"
        hand_total += 11
      elsif val.to_i == 0
        hand_total += 10
      else
        hand_total += val.to_i
      end     
    end

    values.select{ |val| val == "Ace" }.count.times do
      hand_total -= 10 if hand_total > 21
    end
    hand_total.to_i
  end

  def is_busted?
    hand_total(cards) > 21
  end

  def is_21?
    hand_total(cards) == 21
  end

  def busted_message(name)
    "Sorry #{name}, you busted!"
  end

  def win_equal_21_message(name)
    "Congratulations #{name}, you win!"
  end

  def higher_score_message(name)
    "Congratulations #{name}, your score is higher so you win!"
  end  

end  

class Player
  include Hand

  attr_reader :name, :cards

  def initialize(name)
    @name = name
    @cards = []
  end
end

class Dealer 
  include Hand

  attr_accessor :name, :cards

  def initialize
    @name = "Dealer"
    @cards = []
  end
end

class Card
  attr_accessor :suit, :value

  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def to_s
    "#{value} of #{find_suit}"
  end

  def find_suit
    case suit
      when "H" then "Hearts"
      when "D" then "Diamonds"
      when "S" then "Spades"
      when "C" then "Clubs"
    end  
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    ["H", "D", "S", "C"].each do |suit|
      ["2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace"].each do |face_value|
        @cards << Card.new(suit, face_value)
      end
    end
    scramble
  end

  def scramble
    cards.shuffle!
  end

  def deal_card
    cards.pop
  end
end

class Game
  
  attr_reader :player, :dealer
  attr_accessor :deck, :cards

  def initialize
    puts "Welcome to Blackjack"
    puts "\n"
    puts "Please enter your name"
    name = gets.chomp
    puts "OK #{name}, are you ready to lose your shirt?"
    puts "\n"
    @deck = Deck.new
    @player = Player.new(name)
    @dealer = Dealer.new
  end 

  def set_up
    player.cards << deck.deal_card
    puts "#{player.name} has been dealt the #{player.cards[0]}"
    dealer.cards << deck.deal_card
    puts "#{dealer.name} has been dealt the #{dealer.cards[0]}"
    puts "\n"
    player.cards << deck.deal_card
    puts "#{player.name}'s second card is the #{player.cards[1]}"
    dealer.cards << deck.deal_card
    puts "#{dealer.name}'s second card is the #{dealer.cards[1]}"
    puts "#{player.name}'s score is #{player.hand_total(player.cards)}"
    puts "#{dealer.name}'s score is #{dealer.hand_total(dealer.cards)}"
    puts "\n"
  end

  def player_hit
    player.cards << deck.deal_card
    puts "You have drawn the #{player.cards.last} and your score is now #{player.hand_total(player.cards)}"
    puts player.win_equal_21_message(player.name) if player.is_21?
    puts player.busted_message(player.name) if player.is_busted?
    if !(player.is_21? || player.is_busted?)
      begin
        puts "#{player.name}, do you want to hit or stay: enter h for hit, otherwise for stay"
        if gets.chomp.downcase == "h" then player_hit
        else dealer_hit
        end
      end  
    end
  end

  def dealer_hit
    if dealer.hand_total(dealer.cards) < 17 
      begin
        dealer.cards << deck.deal_card
        puts "Dealer has drawn the #{dealer.cards.last} and Dealer score is now #{dealer.hand_total(dealer.cards)}"
      end until dealer.hand_total(dealer.cards) > 16
    end
    puts dealer.win_equal_21_message(dealer.name) if dealer.is_21?
    puts dealer.busted_message(dealer.name) if dealer.is_busted?  
    puts "#{dealer.name} has to stay on #{dealer.hand_total(dealer.cards)}" if !(dealer.is_21? || dealer.is_busted?)   
  end    

  def play_again?
    puts "Hey #{player.name}, do you want to play again? (y/n)"
      continue = gets.chomp.downcase
      if continue == "y"
        begin
          player.cards.clear
          dealer.cards.clear
          set_up
          play
        end
      else
        exit
      end    
  end

  def play
    puts player.win_equal_21_message(player.name) if player.is_21?
    puts dealer.win_equal_21_message(dealer.name) if dealer.is_21? 
    if !(player.is_21? || player.is_busted? || dealer.is_21? || dealer.is_busted?)
      begin
        puts "#{player.name}, do you want to hit or stay: enter h for hit, otherwise for stay"
        if gets.chomp.downcase == "h" then player_hit
        else dealer_hit
        end
      end
    end  
    if !(player.is_21? || player.is_busted? || dealer.is_21? || dealer.is_busted?)
      if player.hand_total(player.cards) > dealer.hand_total(dealer.cards) then puts player.higher_score_message(player.name)
      else puts dealer.higher_score_message(dealer.name)
      end  
    end
    play_again?
  end  
end  

game = Game.new
game.set_up
game.play