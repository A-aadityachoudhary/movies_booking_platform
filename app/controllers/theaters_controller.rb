class TheatersController < ApplicationController
    before_action :authenticate_user!
    load_and_authorize_resource
    def index
        @theaters = @theaters.order(:name)
    end

    def show
    end

    def create
        @theater = current_user.theaters.new(theater_params)
        if @theater.save
            redirect_to @theater, notice: "theater created"
        else
            render :new, status: :unprocessable_entity
        end
    end

    def update
        if @theater.update(theater_params)
            redirect_to @theater, notice: "theater change"
        else 
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @theater.destroy
        redirect_to theaters_path, notice: "theater removed"
    end
    private
    def theater_params
        params.require(:theater).permit(:name, :description, :address, :city, :state, :country, :contact_number, :email, :status)
    end
end
