class NotifyJob < ApplicationJob
    queue_as :default
    
    def perform(domain, email)
        NotificationMailer.notify(domain, email).deliver!
    end

end