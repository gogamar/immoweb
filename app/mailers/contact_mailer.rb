class ContactMailer < ApplicationMailer
  def contact_email(contact)
    @contact = contact
    mail(to: 'info@sistachfinques.com', subject: 'Nou contacte des de la web sistachfinques.com!')
  end
end
