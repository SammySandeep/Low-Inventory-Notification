class ReportJob < ApplicationJob
    queue_as :default

    def perform(shopify_domain, variants)
        Csv::Report.new(shopify_domain, variants).execute()
    end
    
end