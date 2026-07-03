class ScreensController < ApplicationController
    load_and_authorize_resource
    before_action :set_theater
    def index
        @screens = @theater.screens
    end
    def create
        @screen = @theater.screens.new(screen_params)
        if @screen.save
            redirect_to theater_screen_path(@theater, @screen), notice: "screen created"
        else
            render :new, status: :unprocessable_entity
        end
    end
    def destroy
        @screen.destroy
        redirect_to theater_screens_path, notice: "screen destroy"
    end
    private
    def screen_params
        params.require(:screen).permit(:name, :total_seats, :theater_id, :status, :screen_type)
    end
    def set_theater
        @theater = Theater.find(params[:theater_id])
    end
end
