class TownsController < ApplicationController
  before_action :set_town, only: %i[ show edit update destroy ]

  # GET /towns or /towns.json
  def index
    @towns = Town.all
  end

  # GET /towns/1 or /towns/1.json
  def show
  end

  # GET /towns/new
  def new
    @town = Town.new
  end

  # GET /towns/1/edit
  def edit
  end

  # POST /towns or /towns.json
  def create
    @town = Town.new(town_params)

    respond_to do |format|
      if @town.save
        format.html { redirect_to town_url(@town), notice: "Town was successfully created." }
        format.json { render :show, status: :created, location: @town }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @town.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /towns/1 or /towns/1.json
  def update
    respond_to do |format|
      if @town.update(town_params)
        format.html { redirect_to town_url(@town), notice: "Town was successfully updated." }
        format.json { render :show, status: :ok, location: @town }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @town.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /towns/1 or /towns/1.json
  def destroy
    @town.destroy

    respond_to do |format|
      format.html { redirect_to towns_url, notice: "Town was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_town
    @town = Town.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def town_params
    params.require(:town).permit(:name_ca, :name_es, :name_en, :name_fr, :description_ca, :description_es, :description_en, :description_fr, photos: [])
  end
end
