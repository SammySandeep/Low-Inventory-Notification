jQuery(document).on('turbolinks:load', function () {
    $('#reports-datatable').dataTable({
        "processing": true,
        "serverSide": true,
        "columnDefs": [{ "orderable": false, "targets": -1 }],
        "ajax": $('#reports-datatable').data('source'),
        "pagingType": "full_numbers",
        "columns": [
            { "data": "created_at" },
            { "data": "download" }
        ]
    });
});
