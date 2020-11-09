require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    chars = ('A'..'Z').to_a
    10.times do
      @letters << chars[rand(chars.size - 1)]
    end
  end

  def score
    @word = params[:word]
    @grid = params[:letters].split(' ')
    @real = word_true?
    @all_the_letters = all_the_letters?
    @result = if @real == false
                "Sorry but #{@word} does not seem to be a valid english word"
              elsif @all_the_letters == false
                "Sorry but #{@word} can't be build out of #{params[:letters]}"
              else
                session[:current_score] += @word.size
                "Congratulations! #{@word} is a valid word!"
              end
  end

  private

  def word_true?
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    user_serialized = URI.open(url).read
    exist = JSON.parse(user_serialized)
    exist['found'] == true
  end

  def all_the_letters?
    @word.upcase.chars.all? { |letter| @word.count(letter) <= @grid.count(letter) }
  end
end
