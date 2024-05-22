class ContactsController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    @listing = Listing.find_by(id: params[:contact][:listing_id])
    if @contact.save
      ContactMailer.contact_email(@contact, @listing).deliver_now
      redirect_to success_path
    else
      redirect_back(fallback_location: root_path, notice: t("contact_error"))
    end
  end

  def submit
    @property_type = params[:property_type]
    @property_address = params[:property_address]
    @property_bedrooms = params[:property_bedrooms]
    @property_surface = params[:property_surface]
    @contact_info = params[:email_or_phone]

    ContactMailer.with(
      property_type: @property_type,
      property_address: @property_address,
      property_bedrooms: @property_bedrooms,
      property_surface: @property_surface,
      contact_info: @contact_info
    ).evaluation_email.deliver_now

    redirect_to root_path, notice: t('appraisal_request_sent')
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :message, :phone, :budget, :listing_id)
  end
end
