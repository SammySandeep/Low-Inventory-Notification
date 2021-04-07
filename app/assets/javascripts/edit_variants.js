// var variant_edit = document.getElementById("variant_edit");
// var edit_threshold = document.getElementById("edit_threshold");
// var variant_edit = document.getElementById('variant_edit');
// var td = document.getElementsByTagName('td');
// for(var i=0;i<td.length;i++) {
//     var edit_threshold = td[4];
// }
// variant_edit.onclick(function(){
//     edit_threshold.type = 'text';

// });
// var table = document.getElementById('table');
// d = table.getElementsByTagName("tr")[1];
// r = d.getElementsByTagName("td")[3];


$('td').on('click', function() {
    var $this = $(this);
    var $input = $('<input>', {
        value: $this.text(),
        type: 'text',
        blur: function() {
           $this.text(this.value);
        },
        keyup: function(e) {
           if (e.which === 13) $input.blur();
        }
    }).appendTo( $this.empty() ).focus();
});
