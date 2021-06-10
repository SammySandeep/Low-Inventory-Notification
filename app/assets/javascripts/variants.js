jQuery(document).on('turbolinks:load', function() {
    $('#variants-datatable').dataTable({
        "processing": true,
        "serverSide": true,
        "columnDefs": [{ "orderable": false, "targets": -1 }],
        "ajax": $('#variants-datatable').data('source'),
        "pagingType": "full_numbers",
        "columns": [
        {"data": "product_title"},
        {"data": "sku"},
        {"data": "quantity"},
        {"data": "threshold"},
        {"data": "edit"}
        ]
    });
});

function editIconclicked(editElement){
    var previousTd = $(editElement).closest('td');
    var thresholdInputTd = $(previousTd).prev();
    var prevTr = $(thresholdInputTd).closest('tr');
    var variantId = $(prevTr).attr('id'); 
    var thresholdTdValue = $(thresholdInputTd).text();
    $(thresholdInputTd).replaceWith(function () {
        return `<div class="input-group"><input class=form-control-sm min="1" style='display:inline;width:80%;margin-top:10px;margin-bottom:10px;border-color:#2D2B75;' type=number value=${parseInt(thresholdInputTd.text())} > <span class="input-group-btn">
        <button class="cross-btn" style='border:none;color:#212529;' type="submit" onclick=crossButtonPressed(${variantId},${thresholdTdValue});>
            <i class="fa fa-times"></i>
        </button>
      </span>
    </div> `
    });

    $(editElement).replaceWith(function(){
        return `<i class="fa fa-check" aria-hidden="true" onclick=updateIconPressed(${variantId});></i>`
    });
}
    function crossButtonPressed(variantId,thresholdTdValue){
        var variantTr = document.getElementById(variantId);  
        var variantDivElement = $(variantTr).find("div"); 
        $(variantDivElement).replaceWith(function () {
            return `<td class="variant-threshold-text" onclick="updateIconPressed(this);">${thresholdTdValue}</td>`;
        });    
        var editelem = $(variantTr).find("i"); 
        $(editelem).replaceWith(function(){
            return `<i class="fa fa-pencil-square-o" aria-hidden="true" style="font-size:20px;" onclick="editIconclicked(this);"></i>`
        });

    }

// https://stackoverflow.com/questions/62864900/rails-strong-params-not-seeing-params-in-ajax-post-request/62866069#62866069
// Check above link to understand different ways of passing data with ajax

function updateIconPressed(variantId) {
    var updatedThresholdTr = document.getElementById(variantId);
    var inputThresholdElement = $(updatedThresholdTr).find("input");
    var updatedThresholdValue = $(inputThresholdElement).val();
    Rails.ajax({
        url: `/variants/${variantId}`,
        type: "PUT",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: `variant[local_threshold]=${updatedThresholdValue}`
    }) 
}