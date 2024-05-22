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
    @all_operations = Listing.pluck(:operation).uniq
    @all_towns = Listing.pluck(:town_name).uniq
    @page_title = t('home_title')
    @page_description = t('home_description')
  end

  def about_us
    @listing = Listing.first
    @page_title = t('about_us_title')
    @page_description = t('about_us_description')
  end

  def contact_us
    @contact = Contact.new
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
    @page_title = t('contact_us_title')
    @page_description = t('contact_us_description')
  end

  def terms
  end

  def get_operations_and_listing_types
    listings_in_town = Listing.where(town_name: params[:t])
    @listing_types = listings_in_town.distinct.pluck(:listing_subtype)
    render json: {
      listing_types_html: render_to_string(partial: 'listings/listing_types', locals: { listing_types: @listing_types })
    }
  end

  def get_info
  end

  def success
  end
end
