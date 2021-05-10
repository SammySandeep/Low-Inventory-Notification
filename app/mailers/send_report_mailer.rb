class SendReportMailer < ApplicationMailer

    def notify to:, cc:, report_id:
        @report_id = report_id
        mail(to: "#{to}", cc: cc, subject: subject)
    end

    private

    def subject
        "These items will be out of stock soon." 
    end

end
