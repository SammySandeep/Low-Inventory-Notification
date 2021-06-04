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
            download:'<i class="fa fa-download" onclick="downloadIconclicked(this);" aria-hidden="true"></i>'.html_safe,
            DT_RowId: record.id
        }
        end
    end
  
    def get_raw_records
      Report.where(shop_id: options[:shop].id)
    end
  
  end