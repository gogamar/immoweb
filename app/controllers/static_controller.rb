class StaticController < ApplicationController
  skip_before_action :authenticate_user!
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def home
    @listings = Listing.all
    @featured_listings = Listing.where(mark: nil)
                             .where(listing_type: "housing")
                             .where("published_on > ?", Date.today.beginning_of_year)
                             .shuffle
                             .take(6)

    # @new_listings = Listing.order(created_at: :desc).limit(6)
    # @featured_listings = Listing.where(featured: true).where(mark: nil).limit(6)
    @towns = Town.all
  end

  def about_us
    @listing = Listing.first
  end

  def contact_us
    @offices = Office.all
    # The `geocoded` scope filters only offices with coordinates
    @markers = @offices.geocoded.map do |office|
      {
        lat: office.latitude,
        lng: office.longitude,
        info_window_html: render_to_string(partial: "offices/info_window", locals: {office: office}),
        marker_html: render_to_string(partial: "offices/marker")
      }
    end
  end

  def terms
  end

  def get_operations_and_listing_types
    @town = Town.find(params[:town_id])
    @operations = @town.listings.distinct.pluck(:operation)
    @listing_types = @town.listings.distinct.pluck(:listing_subtype)
    render json: {
      operations_html: render_to_string(partial: 'listings/operations', locals: { operations: @operations }),
      listing_types_html: render_to_string(partial: 'listings/listing_types', locals: { listing_types: @listing_types }),
      operations: @operations,
      listing_types: @listing_types
    }
  end

  def get_info

  end
end
