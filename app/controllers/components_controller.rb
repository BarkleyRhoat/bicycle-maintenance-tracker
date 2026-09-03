class ComponentsController < ApplicationController
  before_action :require_login
  before_action :set_component, only: %i[edit update destroy]

  def index
    @components = current_user.components
  end

  def show
    @component = current_user.components.find(params[:id])
    @component_bike_components = @component.bike_components.joins(:bike).where(bikes: { user_id: current_user.id })
    @component_maintenance_logs = @component.maintenance_logs
                                            .joins(:bike)
                                            .where(bikes: { user_id: current_user.id })
                                            .recent
  end

  def new
    @component = current_user.components.build
  end

  def create
    @component = current_user.components.build(component_params)

    if @component.save
      redirect_to component_path(@component), notice: "Component created successfully."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit; end

  def update
    if @component.update(component_params)
      redirect_to component_path(@component), notice: "Component updated successfully."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @component.destroy
    redirect_to components_path, notice: "Component deleted successfully."
  end

private

  def set_component
    @component = current_user.components.find(params[:id])
  end

  def component_params
    params.require(:component).permit(:name, :component_type, :expected_lifespan_km)
  end
end
