class ExportCsvMailer < ApplicationMailer

    def notify email:, csv_string:
        attachments['products.csv'] = {
            mime_type: 'application/csv',
            content: csv_string
        }
        mail(to: "#{email}", subject: 'CSV Export', body: 'CSV Export for edit and upload.')
    end

end