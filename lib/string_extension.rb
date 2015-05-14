module StringExtension
  extend ActiveSupport::Concern

  CAPITALS_REGEX = /[A-Z].*[A-Z]/

  def super_titleize
    split_and_join(/\s+/, ' ') do |word|
      if word.include?('-')
        word.character_split_titleize('-')
      elsif word.include?('/')
        word.character_split_titleize('/')
      elsif word.has_multiple_capitals?
        word
      else
        word.titleize
      end
    end
  end

  protected

  def has_multiple_capitals?
    match(CAPITALS_REGEX)
  end

  def character_split_titleize(character)
    return self if self == character
    split_and_join(character, character) do |word|
      word.super_titleize
    end
  end

  private

  def split_and_join(split_value, join_value)
    split(split_value).map do |word|
      yield(word)
    end.join(join_value)
  end
end

String.send(:include, StringExtension)
