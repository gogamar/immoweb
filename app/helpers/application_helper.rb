module ApplicationHelper
  include Pagy::Frontend

  # def tailwind_classes_for(flash_type)
  #   {
  #     notice: "rounded-md bg-green-50 p-4 m-1",
  #     alert: "rounded-md bg-red-50 p-4 m-1",
  #   }.stringify_keys[flash_type.to_s] || flash_type.to_s
  # end

  def generate_breadcrumbs
    # Define breadcrumbs based on controller and action
    breadcrumbs = []

    # Add the root breadcrumb
    breadcrumbs << { name: t('home'), path: root_path }

    # Add breadcrumbs based on controller and action
    case controller_name
    when 'listings'
      breadcrumbs << { name: t('properties'), path: listings_path }

      if action_name == 'show'
        # Assuming @listing is available in the view context
        breadcrumbs << { name: "#{@listing.ref_number} #{t(@listing.listing_type)} #{@listing.town_name}", path: listing_path(@listing) }
      end

    # Add more cases for other controllers as needed
    when 'static'
      if action_name == 'about_us'
        breadcrumbs << { name: t('about_us'), path: about_us_path }
      elsif action_name == 'contact_us'
        breadcrumbs << { name: t('contact_us'), path: contact_us_path }
      end
    end

    breadcrumbs
  end

  def full_title(page_title = '')
    base_title = "Sistach Finques"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
end
