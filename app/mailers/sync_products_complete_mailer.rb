class SyncProductsCompleteMailer < ApplicationMailer

    def notify domain:, email:
        @domain = domain
        @email = email
        attachments.inline["logo1.png"] = File.read("#{Rails.root}/app/assets/images/logo1.png")        
        attachments.inline["twitter.png"] = File.read("#{Rails.root}/app/assets/images/twitter.png")
        attachments.inline["insta.png"] = File.read("#{Rails.root}/app/assets/images/insta.png")
        attachments.inline["linkedin.png"] = File.read("#{Rails.root}/app/assets/images/linkedin.png")
        mail to: "#{email}", subject: "Sync complete for #{domain}"
    end

end
