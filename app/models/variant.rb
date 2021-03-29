class Variant < ApplicationRecord
    belongs_to :product
    belongs_to :shop
    validates :quantity, numericality: { only_integer: true }, presence: true
    validates :shopify_variant_id, presence: true, uniqueness: true
    validates :threshold, numericality: { only_integer: true }, presence: true
end
