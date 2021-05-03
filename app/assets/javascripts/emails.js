function saveclick(){
    var emailInput = document.getElementById("emailtext").value;
    var isactiveElement = document.getElementById("isactivechck");
    var isactivevalue = $(isactiveElement).prop('checked');
    var hiddenfieldElem = document.getElementById("hiddenfieldelem");
    var shopSettingid = hiddenfieldElem.dataset.shopsettingid;

    Rails.ajax({
        url: `/emails`,
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: `emails_attributes[email]=${emailInput}&emails_attributes[is_active]=${isactivevalue}&emails_attributes[shop_setting_id]=${shopSettingid}`
    }) 

}