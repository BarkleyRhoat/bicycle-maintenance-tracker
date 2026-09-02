class BikesController < ApplicationController
  before_action :require_login
  before_action :set_bike, only: %i[show edit update destroy]

  def index
    @bikes = current_user.bikes
  end

  def show; end

  def new
    @bike = current_user.bikes.build
  end

  def create
    @bike = current_user.bikes.build(bike_params)

    if @bike.save
      redirect_to bike_path(@bike), notice: "Bike added successfully."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit; end

  def update
    if @bike.update(bike_params)
      redirect_to bike_path(@bike), notice: "Bike updated successfully."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @bike.destroy
    redirect_to bikes_path, notice: "Bike deleted successfully."
  end

private

  def set_bike
    @bike = current_user.bikes.find(params[:id])
  end

  def bike_params
    params.require(:bike).permit(:name, :brand)
  end
end
