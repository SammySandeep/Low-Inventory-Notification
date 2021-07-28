$(document).ready(function(){
    $('[data-toggle="tooltip"]').tooltip();
});

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

    if(alertFrequencytext == 6){
        $(secondCol).replaceWith(function () {
            return `<td><select class="form-control" id=${shopId} selected=${parseInt(alertFrequencytext)} style='display:inline;margin-top:10px;margin-bottom:10px;border-color:#2D2B75;'>
            <option value=1 selected>1 hrs</option>
            <option value=6 selected>6 hrs</option>
            <option value=12>12 hrs</option>
            <option value=24>24 hrs</option>
            </select></td>`;
        });
    }
    else if(alertFrequencytext == 12){
        $(secondCol).replaceWith(function () {
            return `<td><select class="form-control" id=${shopId} selected=${parseInt(alertFrequencytext)} style='display:inline;margin-top:10px;margin-bottom:10px;border-color:#2D2B75;'>
            <option value=1 selected>1 hrs</option>
            <option value=6>6 hrs</option>
            <option value=12 selected>12 hrs</option>
            <option value=24>24 hrs</option>
            </select></td>`;
        });
    }
    else if(alertFrequencytext == 24){
        $(secondCol).replaceWith(function () {
            return `<td><select class="form-control" id=${shopId} selected=${parseInt(alertFrequencytext)} style='display:inline;margin-top:10px;margin-bottom:10px;border-color:#2D2B75;'>
            <option value=1 selected>1 hrs</option>
            <option value=6>6 hrs</option>
            <option value=12>12 hrs</option>
            <option value=24 selected>24 hrs</option>
            </select></td>`;
        }); 
    }
    else{
        $(secondCol).replaceWith(function () {
            return `<td><select class="form-control" id=${shopId} selected=${parseInt(alertFrequencytext)} style='display:inline;margin-top:10px;margin-bottom:10px;border-color:#2D2B75;'>
            <option value=1 selected>1 hrs</option>
            <option value=6>6 hrs</option>
            <option value=12>12 hrs</option>
            <option value=24>24 hrs</option>
            </select></td>`;
        });
    }
    $(editElement).replaceWith(function(){
        return `<i class="fa fa-check" aria-hidden="true" style='margin-top:15px;' onclick=updateIconPressedShopSetting(${shopSettingId},${shopId});></i>
        <i class="fa fa-times" style='font-size:20px;color:#212529;' onclick=deleteiconclicked(${globalThresholdTDtext},${alertFrequencytext});></i>`;
    });
}

function deleteiconclicked(globalThresholdTDtext,alertFrequencytext){
    var configurationTable = document.getElementById('configuration-table');
    var firstCol = configurationTable.rows[1].cells[0];
    var secondCol = configurationTable.rows[1].cells[1];
    var thirdCol = configurationTable.rows[1].cells[2];
    $(firstCol).replaceWith(function () {
        return `<td>${globalThresholdTDtext}</td>`;
    });  
    $(secondCol).replaceWith(function () {
        return `<td>${alertFrequencytext}</td>`;
    }); 
    $(thirdCol).replaceWith(function () {
        return ` <td><i class="fa fa-pencil-square-o" aria-hidden="true" style="font-size:20px;" onclick="editclicked(this);"></i></tr>`;
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
    if(isactiveValue == "true"){
        $(isactiveTDElem).replaceWith(function () {
            return `<td><input type="checkbox" value=${isactiveValue} style='display:inline;margin-top:20px;margin-bottom:10px;border-color:#2D2B75;' checked/></td>`;
        }); 
    }
    else{
        $(isactiveTDElem).replaceWith(function () {
            return `<td><input type="checkbox" value=${isactiveValue} style='display:inline;margin-top:20px;margin-bottom:10px;border-color:#2D2B75;'/></td>`;
        }); 
    }

    $(editiconElem).replaceWith(function(){
        return `<i class="fa fa-check" aria-hidden="true"; data-email_id=${emailId} style="margin-top:15px;"  onclick=updateIconPressedEmail(${shopSettingIDEmail},${emailId});></i>
        <i class="fa fa-times" style='font-size:20px;color:#212529;' onclick=crossiconclicked(${emailId},${isactiveValue});></i>`;
    });
    }

    function crossiconclicked(emailId,isactiveValue){
        var updateiconElem = $('[data-email_id*= '+emailId+']');
        var prevTdElem = $(updateiconElem).closest('td'); 
        var updatedIsActiveTd = $(prevTdElem).prev();
        var hiddenField = $(updatedIsActiveTd).prev();
        var updatedemailTd = $(hiddenField).prev();
        var e = updatedemailTd.find('input[type="email"]');
        var emailUpdatedValue = $(e).val();
        $(prevTdElem).replaceWith(function () {
            return `<td><i class="fa fa-pencil-square-o" aria-hidden="true" data-email_id=${emailId} style="font-size:20px;" onclick="editclick(this);"></i></td>`;
        });

        $(updatedIsActiveTd).replaceWith(function () {
            return `<td>${isactiveValue}</td>`;
        });

        $(updatedemailTd).replaceWith(function () {
            return `<td>${emailUpdatedValue}</td>`;
        });
       
    }

    function updateIconPressedEmail(shopSettingIDEmail,emailId) {
        var updateIconElem = $('[data-email_id*= '+emailId+']');
        var prevTdElem = $(updateIconElem).closest('td'); 
        var updatedIsActiveTd = $(prevTdElem).prev();
        var isactivechkbox = updatedIsActiveTd.find('input[type="checkbox"]');
        var updatedisactivevalue = $(isactivechkbox).prop('checked');
        var hiddenfield = $(updatedIsActiveTd).prev();
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
