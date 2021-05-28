class ImportCsvService

    attr_reader :shop_id, :file_path

    def initialize shop_id:, file_path:
        @shop_id = shop_id
        @file_path = file_path
    end

    def execute
        update_variant_from_csv_json.result_status == 1
    end

    private

    def csv_string
        File.open(self.file_path, 'rt').read
    end

    def csv_json
        CSV.parse(csv_string, headers: true).map(&:to_h).to_json
    end

    def update_variant_from_csv_json
        Variant.update_local_threshold_from_csv(shop_id: self.shop_id, csv_json: csv_json)
    end

end