class ReportDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    @view_columns ||= {
      created_at: { source: "Report.created_at", cond: :like, searchable: true},
      download: { searchable: false }
    }
  end
      
  def data
    records.map do |record|
    {  
      created_at: record.created_at,
      download: download_icon(record.id).html_safe,
      DT_RowId: record.id
    }
    end
  end

  def get_raw_records
    Report.where(shop_id: options[:shop].id)
  end

  def download_icon(record_id)
    '<a class="fa fa-download" data-turbolinks="false" href="/reports/download?report_id=' + record_id.to_s + '"></a>'
  end
  
end