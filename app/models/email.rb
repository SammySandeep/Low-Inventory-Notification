class Email < ApplicationRecord
    belongs_to :shop_setting, optional: true
    validates :email, uniqueness: true, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
        message: "Please enter proper email formate" }
end
