class ShowsController < ApplicationController
    before_action :authenticate_user!
    load_and_authorize_resource
    def index
        @shows = Show.include(:movie, :screen)
    end
    def show
    end
    def create
        show = Show.new(show_params)
        if show.save
            redirect_to shows_path, notice: "successfully created!"
        else
            render :new, status: :unprocessable_entity
    end
    def update
        if @show.update(show_params)
            redirect_to @show, notice: "show schedule update"
        else
            render :edit, status: :unprocessable_entity
        end
    end
    
    def destroy
        @show.destroy
        redirect_to shows_path, notice: "show removed"
    end

    private

    def show_params
        params.require(:show).permit(:movie_id, :screen_id, :start_time, :end_time, :ticket_price, :status)
    end
end
