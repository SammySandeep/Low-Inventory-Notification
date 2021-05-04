class SendReportMailer < ApplicationMailer

    def notify(admin:, recipients:, target_obj_key:)
        @url =  "#{ENV['DOWNLOAD_LINK']}#{target_obj_key.gsub(" ","$")}"
        
        if recipients.empty?
            mail to: "#{admin}", subject: "These items will be out of stock soon." 
        else
            mail to: "#{admin}", cc: recipients.join(","), subject: "These items will be out of stock soon."
        end

    end

end
