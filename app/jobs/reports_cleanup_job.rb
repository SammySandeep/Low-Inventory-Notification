class ReportsCleanupJob < ApplicationJob

    queue_as :default

    def perform
        Report.where("created_at <= ?", Date.today - 15.days).destroy_all
    end

end