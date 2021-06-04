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