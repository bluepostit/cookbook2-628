require_relative 'recipe'
require_relative 'view'
require_relative 'scrape_allrecipes_service'

class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    @view = View.new
  end

  def list
    # get recipes from the cookbook
    recipes = @cookbook.all
    # send them to the view to display them
    @view.display(recipes)
  end

  def create
    # get recipe name from view
    name = @view.ask_for('name')
    # get recipe description from view
    description = @view.ask_for('description')

    rating = @view.ask_for_number('rating')
    prep_time = @view.ask_for('preparation time')
    # create a new Recipe instance/object
    recipe = Recipe.new({
      name: name,
      description: description,
      rating: rating,
      prep_time: prep_time
    })
    # add it to the cookbook
    @cookbook.add_recipe(recipe)
  end

  def destroy
    # list the recipes
    list
    # get recipe index from the view
    index = @view.ask_for_index
    # tell cookbook to delete recipe at the given index
    @cookbook.remove_recipe(index)
  end

  def import
    # ask user for a ingredient
    # create URL with ingredient
    # download page of URL
    # create Nokogiri doc of the page
    # search for recipe cards (first 5)
    # for each one:
    #   build a recipe object with parsed info
    # display to user
    # ask user to choose a recipe (index)
    # get chosen recipe object
    # add it to cookbook
    ingredient = @view.ask_for('ingredient to search for')
    recipes = ScrapeAllrecipesService.new(ingredient).call
    @view.display(recipes)
    index = @view.ask_for_index
    recipe = recipes[index]

    @cookbook.add_recipe(recipe)
  end

  def mark_as_done
    # list all recipes
    # ask user to choose one (index)
    # mark it as done
    list
    index = @view.ask_for_index
    @cookbook.mark_as_done(index)
  end
end
