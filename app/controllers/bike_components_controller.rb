class BikeComponentsController < ApplicationController
  before_action :require_login
  before_action :set_bike
  before_action :set_bike_component, only: :destroy

  def new
    @bike_component = @bike.bike_components.build
    @available_components = current_user.components.order(:name)
  end

  def create
    @bike_component = @bike.bike_components.build(bike_component_params)

    if @bike_component.save
      redirect_to bike_path(@bike), notice: "Component installed successfully."
    else
      @available_components = current_user.components.order(:name)
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    bike_component = @bike.bike_components.find(params[:id])
    bike_component.destroy
    redirect_to bike_path(@bike), notice: "Component removed successfully."
  end

  private

  def set_bike
    @bike = current_user.bikes.find(params[:bike_id])
  end

  def set_bike_component
    @bike_component = @bike.bike_components.find(params[:id])
  end

  def bike_component_params
    params.require(:bike_component).permit(:component_id, :installed_on, :current_km)
  end
end
