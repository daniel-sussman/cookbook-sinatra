require_relative 'recipe'
require_relative 'view'
require_relative 'scraper'

class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    @view = View.new
  end

  def list
    @view.display_list(@cookbook.all)
  end

  def add
    name, description, rating = @view.get_name_and_description
    recipe = Recipe.new(name, description, rating)
    @cookbook.create(recipe)
  end

  def remove
    list
    index = @view.get_recipe_to_delete
    @cookbook.destroy(index)
  end

  def import
    index = nil
    while index == nil
      ingredient = @view.get_ingredient
      results = Scraper.new(ingredient).run
      if results.size > 0
        index = @view.which_web_result(results)
      else
        @view.ingredient_search_error(ingredient)
      end
    end
    name, description, rating = results[index]
    @cookbook.create(Recipe.new(name, description, rating))
    @view.report_recipe_added(name)
  end
end
