class MoviesController < ApplicationController
    load_and_authorize_resource
    def index
        @movies = Movie.all
        
    end
end
