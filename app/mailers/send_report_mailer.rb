class SendReportMailer < ApplicationMailer

    def notify to:, cc:, report_id:
        @report_id = report_id
        attachments.inline["logo1.png"] = File.read("#{Rails.root}/app/assets/images/logo1.png")
        attachments.inline["twitter.png"] = File.read("#{Rails.root}/app/assets/images/twitter.png")
        attachments.inline["insta.png"] = File.read("#{Rails.root}/app/assets/images/insta.png")
        attachments.inline["linkedin.png"] = File.read("#{Rails.root}/app/assets/images/linkedin.png")
        attachments.inline["download.png"] = File.read("#{Rails.root}/app/assets/images/download.png")
        mail(to: "#{to}", cc: cc, subject: subject)
    end

    private

    def subject
        "These items will be out of stock soon." 
    end

end
