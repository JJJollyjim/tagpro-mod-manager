(function() {
  $.ajax({
    dataType: "json",
    type: "GET",
    url: "../mixables",
    success: function(data) {},
    error: function() {
      console.error(arguments);
      return alert("An error occurred loading mixable elements.\nDM JJJollyjim on reddit for help");
    }
  });

}).call(this);
