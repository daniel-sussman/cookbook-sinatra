require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require_relative "recipe"
require_relative "cookbook"
require "csv"

get "/" do
  @recipes = [["Chocolate chip cookies", "Delicious recipe!", 5.0]]
  erb :index
end

get "/new" do
  erb :new

end

post "/recipes" do

end

get "/list" do
  erb :list
end

get "/team/:username" do
  puts params[:username]
  "The username is #{params[:username]}"
end

# get "/" do
#   @recipes = []
#   CSV.foreach("recipes.csv") { |row| @recipes << Recipe.new(row[0], row[1], row[2]) }
#   @recipes.to_json
# end
