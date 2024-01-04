require "administrate/base_dashboard"

class ListingDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    address: Field::String,
    bank_owned: Field::Boolean,
    bathrooms: Field::Number,
    bedrooms: Field::Number,
    built_area: Field::Number.with_options(decimals: 2),
    country: Field::String,
    description_ca: Field::Text,
    description_en: Field::Text,
    description_es: Field::Text,
    description_fr: Field::Text,
    double_bedrooms: Field::Number,
    energy_cert: Field::String,
    featured: Field::Boolean,
    features: Field::HasMany,
    idagency: Field::String,
    idfile: Field::String,
    latitude: Field::Number.with_options(decimals: 2),
    lift: Field::Boolean,
    listing_subtype: Field::String,
    listing_type: Field::String,
    loc_precision: Field::String,
    longitude: Field::Number.with_options(decimals: 2),
    namestreet: Field::String,
    new_build: Field::Boolean,
    numberstreet: Field::String,
    operation: Field::String,
    photos_attachments: Field::HasMany,
    photos_blobs: Field::HasMany,
    postcode: Field::String,
    preservation: Field::String,
    province: Field::String,
    ref_number: Field::String,
    region: Field::String,
    rentprice: Field::String.with_options(searchable: false),
    salesprice: Field::String.with_options(searchable: false),
    single_bedrooms: Field::Number,
    speclocation: Field::String,
    status: Field::String,
    terrace: Field::Boolean,
    title_ca: Field::String,
    title_en: Field::String,
    title_es: Field::String,
    title_fr: Field::String,
    town: Field::BelongsTo,
    town_area: Field::String,
    typestreet: Field::String,
    usable_area: Field::Number.with_options(decimals: 2),
    user: Field::BelongsTo,
    year_built: Field::String,
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
    address
    bank_owned
    bathrooms
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    address
    bank_owned
    bathrooms
    bedrooms
    built_area
    country
    description_ca
    description_en
    description_es
    description_fr
    double_bedrooms
    energy_cert
    featured
    features
    idagency
    idfile
    latitude
    lift
    listing_subtype
    listing_type
    loc_precision
    longitude
    namestreet
    new_build
    numberstreet
    operation
    photos_attachments
    photos_blobs
    postcode
    preservation
    province
    ref_number
    region
    rentprice
    salesprice
    single_bedrooms
    speclocation
    status
    terrace
    title_ca
    title_en
    title_es
    title_fr
    town
    town_area
    typestreet
    usable_area
    user
    year_built
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    address
    bank_owned
    bathrooms
    bedrooms
    built_area
    country
    description_ca
    description_en
    description_es
    description_fr
    double_bedrooms
    energy_cert
    featured
    features
    idagency
    idfile
    latitude
    lift
    listing_subtype
    listing_type
    loc_precision
    longitude
    namestreet
    new_build
    numberstreet
    operation
    photos_attachments
    photos_blobs
    postcode
    preservation
    province
    ref_number
    region
    rentprice
    salesprice
    single_bedrooms
    speclocation
    status
    terrace
    title_ca
    title_en
    title_es
    title_fr
    town
    town_area
    typestreet
    usable_area
    user
    year_built
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

  # Overwrite this method to customize how listings are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(listing)
  #   "Listing ##{listing.id}"
  # end
end
