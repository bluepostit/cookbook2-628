require 'open-uri'
require 'nokogiri'

class ScrapeAllrecipesService
  def initialize(ingredient)
    @ingredient = ingredient
  end

  def call
    url = "https://www.allrecipes.com/search/results/?search=#{@ingredient}"
    html = URI.open(url).read
    doc = Nokogiri::HTML(html, nil, 'utf-8')

    recipes = doc.search('.card__detailsContainer').take(5).map do |card|
      name = card.search('.card__title').text.strip
      description = card.search('.card__summary').text.strip
      rating = find_rating(card)
      prep_time = find_prep_time(card)
      Recipe.new({ name: name, description: description, rating: rating, prep_time: prep_time })
    end
    recipes
  end

  def find_rating(card)
    rating_text = card.search('.review-star-text').text.strip
    regex = /\d\.?\d*/
    rating = rating_text.scan(regex).first.to_f || 0
  end

  def find_prep_time(card)
  # find url
  url = card.search('.card__titleLink').attribute('href').value
  # open, download, create Nokogiri doc
  html = URI.open(url).read
  doc = Nokogiri::HTML(html, nil, 'utf-8')

  # search for prep time
  prep_element = doc.search(".recipe-meta-item").find do |element|
    element.text.strip.match?(/prep/i)
  end
  prep_time = prep_element ? prep_element.text.strip.match(/prep:\s+(\w* \w*)/i)[1] : nil
  prep_time
  end
end
