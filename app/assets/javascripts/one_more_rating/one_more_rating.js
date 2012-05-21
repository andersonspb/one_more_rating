$(function() {
    $(".rateit").bind('rated',
        function (event, value) {

            var target = this;

            $.post($(this).data("url"),
                {rateable_type: $(this).data("rateable_type"),
                    rateable_id: $(this).data("rateable_id"),
                    rateable_scope: $(this).data("rateable_scope"),
                    score: value},
                function(data) {
                    $(target).rateit(value, data);
                    $(target).fadeOut().fadeIn();
                    //alert(JSON.stringify(this));
                });
        });
});

