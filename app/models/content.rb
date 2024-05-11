class Content < ApplicationRecord
 has_one_attached :video
 has_one_attached :image

 validate :single_instance


 private

 def single_instance
   # Ensure there is only one instance of Content in the database
   if Content.count > 1
     errors.add(:base, t('content_already_exists'))
   end
 end
end
