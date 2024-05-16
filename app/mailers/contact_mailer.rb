class ContactMailer < ApplicationMailer
  def contact_email(contact, listing)
    @contact = contact
    @listing = listing
    mail(to: 'sistachfinques@gmail.com', subject: 'Nou contacte des de la web sistachfinques.com!')
  end
end
