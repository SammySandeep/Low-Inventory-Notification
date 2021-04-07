class Report < ApplicationRecord
    belongs_to :shop
    validates :url, presence: true

    def self.create_report target_obj, shop
        Report.create(
            shop_id: shop.id,
            url: target_obj.key
        )
    end

end
