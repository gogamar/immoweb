class ServicesController < ApplicationController
  before_action :set_service, only: %i[ show edit update destroy ]

  def index
    @services = policy_scope(Service)
  end

  def show
  end

  def new
    @service = Service.new
    authorize @service
  end

  def edit
  end

  def create
    @service = Service.new(service_params)
    authorize @service

    respond_to do |format|
      if @service.save
        format.html { redirect_to service_url(@service), notice: "Service was successfully created." }
        format.json { render :show, status: :created, location: @service }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @service.update(service_params)
        format.html { redirect_to service_url(@service), notice: "Service was successfully updated." }
        format.json { render :show, status: :ok, location: @service }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @service.destroy

    respond_to do |format|
      format.html { redirect_to services_url, notice: "Service was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_service
    @service = Service.find(params[:id])
    authorize @service
  end

  def service_params
    params.require(:service).permit(:summary_title_ca, :summary_title_es, :summary_title_en, :summary_title_fr, :summary_ca, :summary_es, :summary_en, :summary_fr, :description_title_ca, :description_title_es, :description_title_en, :description_title_fr, :description_ca, :description_es, :description_en, :description_fr)
  end
end
