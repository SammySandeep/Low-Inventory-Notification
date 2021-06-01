class Shopify::AppsController < ApplicationController
    
    skip_before_action :verify_authenticity_token
    
    def uninstalled
        AppDeleteWebhookJob.perform_later(params[:domain])
    end

end
