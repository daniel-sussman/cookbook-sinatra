require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require_relative "recipe"
require_relative "cookbook"
require_relative "scraper"
require "csv"

cookbook = Cookbook.new("recipes.csv")
recipes = cookbook.all

get "/" do
  @recipes = cookbook.all
  erb :index
end

get "/new" do
  erb :new
end

set(:test_parameter) { |p| condition { p != nil } }

post "/new", :test_parameter => :import do
  search_term = params[:import]
  @search_results = Scraper.new(search_term).run
  session[:search_results] = @search_results
  erb :import
end

post "/new" do
  name = params[:name]
  description = params[:description]
  rating = params[:rating]

  recipe = Recipe.new(name, description, rating)
  cookbook.create(recipe)
  @recipes = cookbook.all
  erb :index
end

get "/destroy=:destroy_at_index" do
  cookbook.destroy(params[:destroy_at_index].to_i)
  @recipes = cookbook.all
  erb :index
end

# get "/import?index=:index" do
#   binding.pry
#   index = params[:index]
#   recipe = @search_results[index]

#   if recipe
#     name = recipe.name
#     description = recipe.description
#     rating = recipe.rating
#     cookbook.create(Recipe.new(name, description, rating))
#   end
#   @recipes = cookbook.all
#   erb :index
# end

get "/import" do
  @search_results = session[:search_results]
  index = params[:index]
  recipe = @search_results ? @search_results[index] : nil

  if recipe
    name = recipe.name
    description = recipe.description
    rating = recipe.rating
    cookbook.create(Recipe.new(name, description, rating))
  end
  @recipes = cookbook.all
  erb :index
end

# get "/import=index" do
#   name = params[:name]
#   description = params[:description]
#   rating = params[:rating]
#   cookbook.create(Recipe.new(name, description, rating))
#   @recipes = cookbook.all
#   erb :index
# end


# get "/" do
#   @recipes = []
#   CSV.foreach("recipes.csv") { |row| @recipes << Recipe.new(row[0], row[1], row[2]) }
#   @recipes.to_json
# end
