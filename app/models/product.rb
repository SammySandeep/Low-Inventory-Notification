class Product < ApplicationRecord

    has_many :variants, dependent: :destroy

    belongs_to :shop

    validates :title, presence: true
    validates :shopify_product_id, presence: true, uniqueness: true

end
