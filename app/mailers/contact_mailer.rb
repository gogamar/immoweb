class ContactMailer < ApplicationMailer
  def contact_email(contact, listing=nil)
    @contact = contact
    @listing = listing
    mail(to: 'sistachfinques@gmail.com', subject: 'Nou contacte des de la web sistachfinques.com!')
  end

  def evaluation_email
    @property_type = params[:property_type]
    @property_address = params[:property_address]
    @property_bedrooms = params[:property_bedrooms]
    @property_surface = params[:property_surface]
    @contact_info = params[:contact_info]

    mail(to: 'sistachfinques@gmail.com', subject: "Nova sol·licitud d'avaluació!")
  end
end
