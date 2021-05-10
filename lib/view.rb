class View
  def display(recipes)
    recipes.each_with_index do |recipe, index|
      done = recipe.done? ? 'X' : ' '
      puts "#{index + 1}. [#{done}] #{recipe.name} [#{recipe.prep_time}] (#{recipe.rating}/5)"
    end
  end

  def ask_for(thing)
    puts "Please enter the #{thing}"
    print '> '
    gets.chomp
  end

  def ask_for_number(thing)
    ask_for(thing).to_i
  end

  def ask_for_index
    ask_for_number('recipe number') - 1
  end
end
