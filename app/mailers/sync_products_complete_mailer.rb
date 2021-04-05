class SyncProductsCompleteMailer < ApplicationMailer

    def notify domain:, email:
        @domain = domain
        @email = email
        mail to: "#{email}", subject: "Sync complete for #{domain}"
    end

    # def export_csv(email, file)
    #     attachments['variants.csv'] = File.read(file)
    #     mail(to: "#{email}", subject: 'CSV Export', body: 'CSV Export for edit and upload.')
    # end

end
