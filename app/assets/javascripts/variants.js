var variantTds = document.getElementsByClassName("variant-threshold");

function thresholdTdClicked(variantThresholdTdElement) {
    var variantId = $(variantThresholdTdElement).attr('id');

    $(variantThresholdTdElement).replaceWith(function () {
        return `<input class=variant-threshold-input id=${variantId} type=text value=${parseInt(variantThresholdTdElement.innerText)} onkeypress=thresholdInputKeyPressed(${variantId},event); />`;
    });
}

// https://stackoverflow.com/questions/62864900/rails-strong-params-not-seeing-params-in-ajax-post-request/62866069#62866069
// Check above link to understand different ways of passing data with ajax

function thresholdInputKeyPressed(variantId, event) {
    if (event.keyCode == 13) {
        Rails.ajax({
            url: `/variants/${variantId}`,
            type: "PUT",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            data: `variant[threshold]=${event.target.value}`
        })
    }
}
