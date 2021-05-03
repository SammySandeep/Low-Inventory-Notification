function editclicked(editElement){
    var configurationTable = document.getElementById('configuration-table');
    var firstCol = configurationTable.rows[1].cells[0];
    var globalThresholdTDtext = $(firstCol).text();
    var shopSettingId = $(firstCol).attr('id');
    $(firstCol).replaceWith(function () {
        return `<td><input type=number class="form-control" value=${parseInt(globalThresholdTDtext)} style='display:inline;margin-top:10px;margin-bottom:10px;border-color:#2D2B75;' id=${shopSettingId} /></td>`;
    });  
    var secondCol = configurationTable.rows[1].cells[1];
    var alertFrequencytext = $(secondCol).text();
    var shopId = $(secondCol).attr('id');
    $(secondCol).replaceWith(function () {
        return `<td><select class="form-control" id=${shopId} value=${parseInt(alertFrequencytext)} style='display:inline;margin-top:10px;margin-bottom:10px;border-color:#2D2B75;'>
        <option value=0>0</option>
        <option value=1>1</option>
        <option value=7>7</option>
        <option value=24>24</option>
      </select></td>`;
    });
    $(editElement).replaceWith(function(){
        return `<i class="fa fa-check" aria-hidden="true" onclick=updateIconPressedShopSetting(${shopSettingId},${shopId});></i>`;
    });
}

// https://stackoverflow.com/questions/62864900/rails-strong-params-not-seeing-params-in-ajax-post-request/62866069#62866069
// Check above link to understand different ways of passing data with ajax

function updateIconPressedShopSetting(shopSettingId,shopId) {
    var updatedglobalThresholdValue = document.getElementById(shopSettingId).value;
    var updatedalertFrequencyValue = document.getElementById(shopId).value;
    Rails.ajax({
        url: `/shop_settings/${shopSettingId}`,
        type: "PUT",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: `shop_setting[global_threshold]=${updatedglobalThresholdValue}&shop_setting[alert_frequency]=${updatedalertFrequencyValue}`
    }) 
} 

function editclick(editiconElem){
    var emailId = $(editiconElem).attr('data-email_id');
    var previousTdElem = $(editiconElem).closest('td');
    var isactiveTDElem = $(previousTdElem).prev();
    var isactiveValue = $(isactiveTDElem).text();
    var hiddenField1 = $(isactiveTDElem).prev();
    var shopSettingIDEmail = $(hiddenField1).attr('id');
    var emailTdElem = $(hiddenField1).prev();
    var emailElemText = $(emailTdElem).text();

    $(emailTdElem).replaceWith(function () {
        return `<td><input type="email" class="form-control" value=${emailElemText} style='display:inline;margin-top:10px;margin-bottom:10px;border-color:#2D2B75;'/></td>`;
    }); 

    $(isactiveTDElem).replaceWith(function () {
        return `<td><input type="checkbox" value=${isactiveValue} style='display:inline;margin-top:20px;margin-bottom:10px;border-color:#2D2B75;'/></td>`;
    }); 

    $(editiconElem).replaceWith(function(){
        return `<i class="fa fa-check" aria-hidden="true"; data-email_id=${emailId} style="margin-top:15px;"  onclick=updateIconPressedEmail(${shopSettingIDEmail},${emailId});></i>`;
    });
}
    function updateIconPressedEmail(shopSettingIDEmail,emailId) {
        var updateiconElem = $('[data-email_id*= '+emailId+']');
        var prevTdElem = $(updateiconElem).closest('td'); 
        var updatedisactiveTd = $(prevTdElem).prev();
        var isactivechkbox = updatedisactiveTd.find('input[type="checkbox"]');
        var updatedisactivevalue = $(isactivechkbox).prop('checked');
        var hiddenfield = $(updatedisactiveTd).prev();
        var updatedemailTd = $(hiddenfield).prev();
        var emailinputElem = updatedemailTd.find('input[type="email"]');
        var emailUpdatedValue = $(emailinputElem).val();
    
        Rails.ajax({
            url: `/shop_settings/${shopSettingIDEmail}`,
            type: "PUT",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            data: `shop_setting[emails_attributes][id]=${emailId}&shop_setting[emails_attributes][email]=${emailUpdatedValue}&shop_setting[emails_attributes][is_active]=${updatedisactivevalue}`
        }) 

    }

function deleteclick(emailDeleteIcon){
    alert("Are you sure you want to delete?");
    var emailIdDelete = $(emailDeleteIcon).attr('data-email_id_delete');
    var deleteiconTd = $(emailDeleteIcon).closest('td');
    var shopSettingidToDelete = $(deleteiconTd).next();
    var x = $(shopSettingidToDelete).attr('id');

    Rails.ajax({
        url: `/emails/${emailIdDelete}`,
        type: "DELETE",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: `emails_attributes[shop_setting_id]=${x}`
    }) 
}