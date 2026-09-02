class MaintenanceLogsController < ApplicationController
  before_action :require_login
  before_action :set_bike
  before_action :set_maintenance_log, only: %i[show edit update destroy]

  def index
    @maintenance_logs = @bike.maintenance_logs.recent
  end

  def show; end

  def new
    @maintenance_log = @bike.maintenance_logs.build
    @installed_components = @bike.components.order(:name)
  end

  def create
    @maintenance_log = @bike.maintenance_logs.build(maintenance_log_params)

    if @maintenance_log.save
      redirect_to bike_maintenance_log_path(@bike, @maintenance_log), notice: "Log created successfully."
    else
      @installed_components = @bike.components.order(:name)
      render :new, status: :unprocessable_content
    end
  end

  def edit
    @installed_components = @bike.components.order(:name)
  end

  def update
    if @maintenance_log.update(maintenance_log_params)
      redirect_to bike_maintenance_log_path(@bike, @maintenance_log), notice: "Log updated successfully."
    else
      @installed_components = @bike.components.order(:name)
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @maintenance_log.destroy
    redirect_to bike_maintenance_logs_path(@bike), notice: "Log deleted successfully."
  end

private

  def set_bike
    @bike = current_user.bikes.find(params[:bike_id])
  end

  def set_maintenance_log
    @maintenance_log = @bike.maintenance_logs.find(params[:id])
  end

  def maintenance_log_params
    params.require(:maintenance_log).permit(:service_date, :description, :km_at_service, :component_id)
  end
end
