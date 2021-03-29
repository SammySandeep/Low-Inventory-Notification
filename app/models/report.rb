class Report < ApplicationRecord
    belongs_to :shop
    validates :url, presence: true
end
