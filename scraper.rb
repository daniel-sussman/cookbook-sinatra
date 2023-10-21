require 'nokogiri'
require 'open-uri'
require_relative 'recipe'

class Scraper
  def initialize(ingredient)
    @ingredient = ingredient
    @url = "https://www.allrecipes.com/search?q=#{ingredient}"
  end

  def run
    html = URI.open(@url).read
    parsed_html = Nokogiri::HTML.parse(html)
    results = []
    parsed_html.search('.mntl-card').each do |element|
      name = element.search('.card__title-text').text,
      href = element.attribute("href").value.strip
      description, rating = get_description_and_rating(href)
      results << Recipe.new(name[0], description, rating) if rating
      break if results.size == 5
    end
    return results
  end

  def get_description_and_rating(url)
    html = URI.open(url).read
    parsed_html = Nokogiri::HTML.parse(html)
    if parsed_html.search('#article-subheading_1-0')[0] == nil
      description = "[No description given.]"
    else
      description = parsed_html.search('#article-subheading_1-0')[0].text.lstrip
    end
    if parsed_html.search('#mntl-recipe-review-bar__rating_1-0')[0] == nil
      rating = nil
    else
      rating = parsed_html.search('#mntl-recipe-review-bar__rating_1-0')[0].text.lstrip
    end
    return [description, rating]
  end
end
