class MoviesController < ApplicationController
    load_and_authorize_resource
    def index
        @movies = Movie.where(status: 1)
    end

    def show
        @movie = Movie.find(params[:id])
        @shows = @movie.shows.where('start_time > ?', Time.current).includes(screen: :theater).order(:start_time)
    end
end
