class Contact < ApplicationRecord

  validates :name, presence: true
  validates :email, presence: true


  BUDGET = [
    "0-100.000€",
    "100.000-200.000€",
    "200.000-300.000€",
    "300.000-400.000€",
    "400.000-500.000€",
    "500.000-600.000€",
    "> 600.000€"
  ]
end
