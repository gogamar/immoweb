class StaticController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    @listings = Listing.all
    @sale_listings = Listing.where(operation: "sale")
  end

  def sale_listings
    @sale_listings = Listing.where(operation: "sale")
  end

  def rental_listings
    @rental_listings = Listing.where(operation: "rent")
    @sale_listings = Listing.where(operation: "sale")
  end

  def about_us
    @listing = Listing.first
  end

  def contact_us
  end

  def terms
  end
end
