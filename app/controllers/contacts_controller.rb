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

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :message, :phone, :budget, :listing_id)
  end
end
