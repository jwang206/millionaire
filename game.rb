require 'json'
require_relative 'player.rb'
require_relative 'purse.rb'
require_relative 'questions.rb'

class Game

  def initialize
    @game_number = 0
    @question_number = 0
    @answer_number = 0
    @end_game = false
    @purse = Purse.new
    @player = Player.new
    @questions = Questions.new
    @available_lifelines = ["50/50", "Ask the Audience", "Phone a Friend"]
  end

  def start
    until game_is_over
      system "clear"
      puts "Welcome to Who Wants to Be A Millionare!\n\n"
      retrieve_question
      get_answers
      list_answers
      player_options
      if game_is_over
        start_over?
      end
    end
  end

  def get_answers
    @answers = @questions.get_choices
    @correct_answer = @questions.get_answer
  end

  def player_options
    puts "---------------------------------------------------------------"
    options = [
      "Answer Question",
      "Walk Away",
      "Use a Lifeline"
    ]

    # delete lifeline option if it's all used
    if @available_lifelines == []
      @options.delete("Use a Lifeline")
    end

    # prompt user to get input

    number = 1

    # show available options
    options.each do |option|
      puts "[#{number}] #{options[number-1]}"
      number += 1
    end
    puts

    # get user input
    print "Choose an option[1-3]:"
    choice = gets.chomp.to_i

    if choice == 1
      puts
      evaluate_answer
    elsif choice == 2
      puts "\nThanks for playing! You walk away with #{@purse.get_value}!"
      @end_game = true
      game_is_over
    elsif choice == 3
      puts
      choose_lifeline
    end
  end

  def retrieve_question
    puts "Question #{@question_number + 1} -  " + "#{@questions.get_question}"
  end

  def list_answers
    choice_number = 1
    @answers.each do |choice|
      puts "#{choice_number}. #{choice}"
      choice_number += 1
    end
    puts
  end

  def evaluate_answer
    print "Your Answer: "
    @user_answer = gets.chomp.to_i - 1
    @question_number += 1
    if @user_answer == @correct_answer
      @purse.increment
      puts "Correct! You have now earned #{@purse.get_value}!"
    else
      puts "Sorry, wrong answer, you walk away with #{@purse.get_tier_value}."
      @end_game = true
    end
    puts "[ANY KEY] to Continue"
    gets.chomp
  end

  def choose_lifeline
    puts "Please choose a lifeline: "
    number = 1

    @available_lifelines.each do |lifeline|
      puts "#{number}. #{@available_lifelines[number-1]}"
      number += 1
    end

    print "Choice: "
    choice = gets.chomp.to_i
    if choice == 1
      @lifeline = @available_lifelines[0]
      @available_lifelines.delete_at(0)
    elsif choice == 2
      @lifeline = @available_lifelines[1]
      @available_lifelines.delete_at(1)
    elsif choice == 3
      @lifeline = @available_lifelines[2]
      @available_lifelines.delete_at(2)
    end

    if @lifeline == "50/50"
      fifty_fifty
    elsif @lifeline == "Ask the Audience"
      ask_audience
    elsif @lifeline == "Phone a Friend"
      phone_friend
    end
  end

  def fifty_fifty
    until @answers.length == 2
      number = rand(0..3)
      unless number == @correct_answer
        @answers.delete_at(number)
        if number < @correct_answer
          @correct_answer -= 1
        end
      end
    end
    system "clear"
    retrieve_question
    list_answers
    player_options
  end

  def ask_audience
  end

  def phone_friend
  end

  def game_is_over
    if @question_number > 15
      return true
    elsif @end_game
      return true
    else
      return false
    end
  end

  def start_over?
    puts "[1] Play again"
    puts "[2] Quit"
    choice = gets.chomp.to_i
    if choice == 1
      game = Game.new
      game.start
    end
  end
end
