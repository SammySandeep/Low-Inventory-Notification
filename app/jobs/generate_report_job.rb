class GenerateReportJob < ApplicationJob
    queue_as :default

    def perform(shop, products)
        target_obj = Csv::GenerateReport.new(shop, products).execute()
        Report.create_report(target_obj, shop)
        admins = []
        recipients = [] 

        shop.shop_setting.emails.each do |email|
            if email.is_active?
                if email.is_admin?
                    admins << email.email
                else
                    recipients << email.email
                end
            end
        end

        SendReportMailer.notify(admins: admins, recipients: recipients, target_obj_key: target_obj.key).deliver_later
    end
    
end