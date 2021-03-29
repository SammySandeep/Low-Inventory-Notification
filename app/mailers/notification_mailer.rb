class NotificationMailer < ApplicationMailer

    def notify(domain, email)
        @domain = domain
        mail to: "#{email}", subject: "Sync complete for #{domain}"
    end

end
