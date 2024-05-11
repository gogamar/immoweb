class Service < ApplicationRecord
  validate :validate_max_services, on: :create

  private

  def validate_max_services
    if Service.count >= 4
      errors.add(:base, "Ja existeixen 4 serveis")
    end
  end
end
