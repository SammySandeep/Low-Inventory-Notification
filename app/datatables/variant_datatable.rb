class VariantDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    @view_columns ||= {
      product_title: { source: "Product.title",cond: :like, searchable: true},
      sku:  { source: "Variant.sku",cond: :like, searchable: true},
      quantity:  { source: "Variant.quantity",cond: :eq, searchable: true },
      threshold: { source: "Variant.local_threshold" },
    }
  end
    
  def data
    records.map do |record|
      {  
        product_title: record.product.title,
        sku: record.sku,
        quantity: record.quantity,
        threshold: record.threshold,  
      }
    end
  end

  def get_raw_records
    Variant.joins(:product).where(shop_id: options[:shop].id)
  end

end