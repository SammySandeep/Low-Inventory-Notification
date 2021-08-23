class Email < ApplicationRecord

    belongs_to :shop_setting, optional: true

    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Incorrect Email format" }

end
