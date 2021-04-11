function changetd(tdele){

        tdele.onclick = function() {
        var $this = $(this);
        var id = this.id;
        var $input = $('<input>', {
            value: $this.text(),
            type: 'text',
            blur: function() {
            $this.text(this.value);
            },
            keyup: function(e) {
            if (e.which === 13)
             {
                Rails.ajax({
                    url: "/variants",
                    type: "put",
                    data: "",
                    success: function(data) {},
                    error: function(data) {}
                  })
             }
            }
        }).appendTo( $this.empty() ).focus();
    };
}

