class Product < ApplicationRecord
    belongs_to :shop
    has_many :variants, dependent: :destroy
    validates :title, presence: true
    validates :shopify_product_id, presence: true, uniqueness: true
end
