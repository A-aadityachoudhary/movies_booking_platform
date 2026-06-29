class Admin::MoviesController < ApplicationController
    before_action :authenticate_user!
    load_and_authorize_resource
    def index
        @movies = Movie.all
    end
    def show
        
    end
    def edit
        
    end
    def create
        @movie = Movie.new(movie_params)
        if @movie.save
            redirect_to admin_movie_path(@movie), notice: "new movie created"
        else
            render :new, status: :unprocessable_entity
        end
    end
    def destroy
        @movie.destroy
        redirect_to admin_movies_path, notice: "movie removed"
    end
    private
    def movie_params
        params.require(:movie).permit(:description, :duration, :genre, :language, :release_date, :title, :status)
    end
end
