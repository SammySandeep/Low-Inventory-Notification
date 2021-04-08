var x = [];
tds = document.getElementsByTagName('td');
for(var i=3;i<tds.length;i=i+4){
    x.push(tds[i]);
}

for(var j=0;j<x.length;j++){
x[j].onclick = function() {
    var $this = $(this);
    var id = this.id;
    // console.log(id);
    var $input = $('<input>', {
        value: $this.text(),
        type: 'text',
        blur: function() {
           $this.text(this.value);
        },
        keyup: function(e) {
           if (e.which === 13){
               var value = this.value;
               console.log(value);
               console.log(id);
            Rails.ajax({
                url: "/variants",
                type: "PUT",
                data: {id,value},
                success: function(data) {
                    console.log(data);
                },
                error: function(data) {}
              })
           }
           $input.blur();
           
        }
    }).appendTo( $this.empty() ).focus();
};
}
