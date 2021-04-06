class ReportJob < ApplicationJob
    queue_as :default

    def perform(shopify_domain, products)
        Csv::Report.new(shopify_domain, products).execute()
    end
    
end