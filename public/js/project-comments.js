// Generated by CoffeeScript 1.3.3
(function() {

  $(document).on("submit", "#add-comment-form", function(e) {
    var el;
    e.preventDefault();
    el = $(this);
    return el.ajaxSubmit({
      success: function(data) {
        var new_comment;
        if (data.status === "success") {
          new_comment = $(data.html);
          new_comment.find("span.timeago").timeago();
          $(".comments-list").append(new_comment);
          return el.resetForm();
        }
      }
    });
  });

}).call(this);
