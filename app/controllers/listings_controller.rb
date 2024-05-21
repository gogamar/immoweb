class ListingsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[ index show ]
  before_action :set_listing, only: %i[ show edit update destroy ]

  def index
    @listings = policy_scope(Listing)
    @listings = @listings.where(town_name: params[:t]) if params[:t].present?
    @listing_types = @listings.present? ? @listings.pluck(:listing_subtype).uniq : Listing.pluck(:listing_subtype).uniq
    if params[:ot].present? && params[:ot] == t('rent')
      @listings = @listings.where(operation: 'rent')
    elsif params[:ot].present? && params[:ot] == t('sale')
      @listings = @listings.where(operation: 'sale')
    end
    @listings = @listings.where(listing_subtype: params[:pt]) if params[:pt].present?
    @pagy, @listings = pagy(@listings, page: params[:page], items: 9)
    @all_listings = Listing.all
    @pagy, @all_listings = pagy(@all_listings, page: params[:page], items: 9)
    @all_operations = Listing.pluck(:operation).uniq
    @operations = @listings.present? ? @listings.pluck(:operation).uniq : @all_operations
    @all_listing_subtypes = Listing.pluck(:listing_subtype).uniq
    @towns = Town.all
    @all_salesprices = Listing.pluck(:salesprice)
    i = 40000
    salesprices_1 = Array.new(18){i+=20000}
    salesprices_2 = Array.new(12){i+=50000}
    salesprices_3 = Array.new(10){i+=100000}
    @salesprices_array = salesprices_1 + salesprices_2 + salesprices_3
    @page_title = params[:ot].present? && params[:ot] == t('for_rent') ? t('listings_rent_title') : t('listings_sale_title')
    @page_description = params[:ot].present? && params[:ot] == t('for_rent') ? t('listings_rent_description') : t('listings_sale_description')
    # fixme: customize page meta keywords for each page
    listings_link = params[:ot].present? && params[:ot] == t('for_rent') ? listings_path(ot: 'rent') : listings_path(ot: 'sale')
  end

  def show
    @contact = Contact.new
    salesprice_or_rentprice = @listing.operation == 'sale' ? @listing.salesprice : @listing.rentprice
    operation = @listing.operation == 'sale' ? t('for_sale') : t('for_rent')
    @page_title = t('single_property_title', address: @listing.address, town: @listing.town_name, operation: operation, salesprice_or_rentprice: salesprice_or_rentprice)
    @page_description = t('single_property_description', address: @listing.address, town: @listing.town_name, operation: operation, salesprice_or_rentprice: salesprice_or_rentprice)
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
