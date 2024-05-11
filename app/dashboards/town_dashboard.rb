require "administrate/base_dashboard"

class TownDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    description_ca: Field::Text,
    description_en: Field::Text,
    description_es: Field::Text,
    description_fr: Field::Text,
    listings: Field::HasMany,
    name_ca: Field::String,
    name_en: Field::String,
    name_es: Field::String,
    name_fr: Field::String,
    photos_attachments: Field::HasMany,
    photos_blobs: Field::HasMany,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    name_ca
    name_es
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    description_ca
    description_en
    description_es
    description_fr
    listings
    name_ca
    name_en
    name_es
    name_fr
    photos_attachments
    photos_blobs
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    description_ca
    description_en
    description_es
    description_fr
    listings
    name_ca
    name_en
    name_es
    name_fr
    photos_attachments
    photos_blobs
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how towns are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(town)
  #   "Town ##{town.id}"
  # end
end
