class ListingsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[ index show ]
  before_action :set_listing, only: %i[ show edit update destroy ]

  def index
    @all_listings = policy_scope(Listing)
    @listings_in_town = @all_listings.where(town_id: params[:town_id]) if params[:town_id].present?
    @listings = @listings_in_town.where(operation: params[:ot]) if params[:ot].present?
    @listings = @listings.where(listing_subtype: params[:pt]) if params[:pt].present?
    @listing_types = @listings_in_town.present? ? @listings_in_town.pluck(:listing_subtype).uniq : Listing.pluck(:listing_subtype).uniq
    @operations = @listings_in_town.present? ? @listings_in_town.pluck(:operation).uniq : Listing.pluck(:operation).uniq
    @towns = Town.all
    @all_salesprices = @all_listings.pluck(:salesprice)
    i = 40000
    salesprices_1 = Array.new(18){i+=20000}
    salesprices_2 = Array.new(12){i+=50000}
    salesprices_3 = Array.new(10){i+=100000}
    @salesprices_array = salesprices_1 + salesprices_2 + salesprices_3
  end

  def show
    @contact = Contact.new
  end

  def new
    @listing = Listing.new
    authorize @listing
  end

  def edit
  end

  def create
    @listing = Listing.new(listing_params)
    authorize @listing

    respond_to do |format|
      if @listing.save
        format.html { redirect_to listing_url(@listing), notice: "Listing was successfully created." }
        format.json { render :show, status: :created, location: @listing }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /listings/1 or /listings/1.json
  def update
    respond_to do |format|
      if @listing.update(listing_params)
        format.html { redirect_to listing_url(@listing), notice: "Listing was successfully updated." }
        format.json { render :show, status: :ok, location: @listing }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /listings/1 or /listings/1.json
  def destroy
    @listing.destroy

    respond_to do |format|
      format.html { redirect_to listings_url, notice: "Listing was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_listing
    @listing = Listing.find(params[:id])
    authorize @listing
  end

  def listing_params
    params.require(:listing).permit(:status, :ref_number, :idfile, :idagency, :listing_type, :latitude, :longitude, :address, :typestreet, :namestreet, :numberstreet, :postcode, :speclocation, :region, :province, :country, :usable_area, :built_area, :operation, :salesprice, :rentprice, :title_ca, :title_es, :title_en, :title_fr, :description_ca, :description_es, :description_en, :description_fr, :bedrooms, :terrace, :lift, :featured, :town_name, :mark, :local_status, :listing_subtype, :new_build, :bank_owned, :town_area, :loc_precision, :preservation, :year_built, :energy_cert, :bedrooms, :double_bedrooms, :single_bedrooms, :bathrooms, :town_id, :user_id, photos: [])
  end
end
