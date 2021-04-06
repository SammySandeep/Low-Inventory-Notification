class SendReportMailer < ApplicationMailer

    def notify(admins:, recipients: 0, target_obj_key:)
        
        if recipients.empty?
            mail to: admins.join(","), subject: "These items will be out of stock soon." 
        else
            mail to: admins.join(","), cc: recipients.join(","), subject: "These items will be out of stock soon."
        end

    end

end
