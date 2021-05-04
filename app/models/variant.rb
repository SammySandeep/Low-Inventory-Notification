class Variant < ApplicationRecord
    
    belongs_to :product
    belongs_to :shop
    
    validates :quantity, numericality: { only_integer: true }, presence: true
    validates :shopify_variant_id, presence: true, uniqueness: true
    validates :local_threshold, numericality: { only_integer: true }, presence: true, allow_nil: true

    def threshold
        if self.local_threshold.present?
            self.local_threshold
        else
            self.product.shop.shop_setting.global_threshold
        end
    end

end
