class SyncProductsCompleteMailer < ApplicationMailer

    def notify domain:, email:
        @domain = domain
        @email = email
        mail to: "#{email}", subject: "Sync complete for #{domain}"
    end

end
