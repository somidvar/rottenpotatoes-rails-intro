class Movie < ActiveRecord::Base
    def self.with_ratings (selected_ratings)
        Movie.where(rating: selected_ratings.map(&:upcase))
    end
end
