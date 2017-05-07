class Contact < ActiveRecord::Base
    # Wymagania do formularza Contact form
    validates :name, presence: true
    validates :email, presence: true
    validates :comments, presence: true
end