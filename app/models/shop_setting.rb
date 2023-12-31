class ShopSetting < ApplicationRecord
    
    belongs_to :shop
    
    has_many :emails
    accepts_nested_attributes_for :emails, allow_destroy: true, reject_if: proc { |att| att['email'].blank? }
    
    validates :global_threshold, numericality: { only_integer: true }, presence: true
    validates :alert_frequency, numericality: { only_integer: true }, presence: true
    validate :check_alert_frequency
    
    private

    def check_alert_frequency
        unless [1,6,12,24].include? self.alert_frequency
            errors.add(:alert_frequency, "Must be specified frequency value")
        end
    end
end
