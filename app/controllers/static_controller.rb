class StaticController < ApplicationController
  skip_before_action :authenticate_user!

  def home
  end

  def all_listings
  end

  def about_us
  end

  def contact_us
  end

  def terms
  end
end
