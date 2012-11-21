jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()

  # Add bootstrap wysiwyg editor
  $('.wysiwyg').wysihtml5
    image: false
