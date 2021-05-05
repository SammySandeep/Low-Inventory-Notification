class SyncProductsCompleteMailer < ApplicationMailer

    def notify domain:, email:
        @domain = domain
        @email = email
        attachments.inline["logo.png"] = File.read("#{Rails.root}/app/assets/images/logo.png")
        attachments.inline["banner.jpg"] = File.read("#{Rails.root}/app/assets/images/banner.jpg")
        attachments.inline["twitter.png"] = File.read("#{Rails.root}/app/assets/images/twitter.png")
        attachments.inline["insta.png"] = File.read("#{Rails.root}/app/assets/images/insta.png")
        attachments.inline["linkd.png"] = File.read("#{Rails.root}/app/assets/images/linkd.png")
        attachments.inline["icon.png"] = File.read("#{Rails.root}/app/assets/images/icon.png")
        mail to: "#{email}", subject: "Sync complete for #{domain}"
    end

end
