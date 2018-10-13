# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
  #fail "Unimplemented"
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  #fail "Unimplemented"
  regexp = /#{e1}.*#{e2}/m
  page.body.should =~regexp
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  
  split_ratings = rating_list.split
  split_ratings.each do |rating|
    #puts uncheck
    if uncheck == "un"
      uncheck("ratings_#{rating}")
    else
      check("ratings_#{rating}")
    end
    #puts(split_ratings)
  end
  #fail "Unimplemented"
end

When /I press 'Refresh'/ do
  click_button('Refresh')
end

Then /I should see the movies: "(.*)"/ do |movies|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  
  seen_movie_titles = movies.split("  ")
  seen_movie_titles.each do |movie|
    expect(page).to have_content(movie)
    #Then I should see movie
  end
end

Then /I should not see the movies: "(.*)"/ do |movies|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  
  no_movie_titles = movies.split("  ")
  no_movie_titles.each do |movie|
      expect(page).to have_no_content(movie)
  end
end


Then /I should see all the movies/ do
  array_of_movies = Array.new
  Movie.all.each do |movie|
    array_of_movies.insert(movie.title)
  end
  
  array_of_movies.each do |movie|
    if page.respond_to? :should
      page.should have_content(movie)
    else
      assert page.has_content?(movie)
    end
  end
end
