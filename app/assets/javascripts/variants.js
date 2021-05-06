function editIconclicked(editElement){
    var editIconid = editElement.id;   
    var previousTd = $(editElement).closest('td');
    var thresholdInputTd = $(previousTd).prev();
    var variantId = $(thresholdInputTd).attr('id');   
    $(thresholdInputTd).replaceWith(function () {
        return `<input class=form-control-sm min="1" style='display:inline;width:90%;margin-top:10px;margin-bottom:10px;border-color:#2D2B75;' id=${variantId} type=number value=${parseInt(thresholdInputTd.text())} />`;
    });
    $(editElement).replaceWith(function(){
        return `<i class="fa fa-check" aria-hidden="true" onclick=updateIconPressed(${variantId});></i>`
    });
}

// https://stackoverflow.com/questions/62864900/rails-strong-params-not-seeing-params-in-ajax-post-request/62866069#62866069
// Check above link to understand different ways of passing data with ajax

function updateIconPressed(variantId) {
    var updatedThresholdValue = document.getElementById(variantId).value;
    Rails.ajax({
        url: `/variants/${variantId}`,
        type: "PUT",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: `variant[local_threshold]=${updatedThresholdValue}`
    }) 
}