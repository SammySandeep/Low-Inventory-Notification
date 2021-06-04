jQuery(document).on('turbolinks:load', function()  {
    $('#reports-datatable').dataTable({
        "processing": true,
        "serverSide": true,
        "columnDefs": [{ "orderable": false, "targets": -1 }],
        "ajax": $('#reports-datatable').data('source'),
        "pagingType": "full_numbers",
        "columns": [
        {"data": "created_at"},
        {"data": "download"}
        ]
    });
});

function downloadIconclicked(reportsdownloadicon) {
    var previousTd1 = $(reportsdownloadicon).closest('td');
    var reportsTr = $(previousTd1).closest('tr');
    var reportId = $(reportsTr).attr('id'); 
    Rails.ajax({
        url: `/reports/download`,
        type: "GET",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: `report_id=${reportId}`
    }) 
}