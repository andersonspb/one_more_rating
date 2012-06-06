$(function() {
    $(".rateit").bind('rated',
        function (event, value) {

            var target = this;

            $.post($(this).data("url"),
                {rateable_type: $(this).data("rateable_type"),
                    rateable_id: $(this).data("rateable_id"),
                    score: value},
                function(data) {
                    period = $(target).data("period");
                    $(target).rateit(value, data.score[period != null ? period : "total"]);
                    $(target).fadeOut().fadeIn();
                });
        });
});

