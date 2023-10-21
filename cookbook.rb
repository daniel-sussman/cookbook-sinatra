require "csv"
require_relative 'recipe'

class Cookbook
  def initialize(csv_file_path)
    @csv_file_path = csv_file_path
    @recipes = []
    load_csv
  end

  def all
    @recipes
  end

  def create(recipe)
    @recipes << recipe
    save_csv
  end

  def destroy(recipe_index)
    @recipes.delete_at(recipe_index)
    save_csv
  end

  private

  def load_csv
    CSV.foreach(@csv_file_path) { |row| @recipes << Recipe.new(row[0], row[1], row[2]) }
  end

  def save_csv
    CSV.open(@csv_file_path, "wb") do |csv|
      @recipes.each { |recipe| csv << [recipe.name, recipe.description, recipe.rating] }
    end
  end
end



# X initialize(csv_file_path) which loads existing Recipe from the CSV
# x all which returns all the recipes
# create(recipe) which creates a recipe and adds it to the cookbook
# destroy(recipe_index) which removes a recipe from the cookbook.

# To load and store the data in the CSV, we will implement 2 private methods:

#     load_csv, which loads the existing data from the CSV file to our application
#     save_csv, which adds the new recipes as new rows in our CSV file
