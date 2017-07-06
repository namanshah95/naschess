# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).on 'change', '#group_children', (evt) ->
    $.ajax 'update_host',
      type: 'GET'
      dataType: 'script'
      data: {
        children: $("#group_children").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{errorThrown}")
      success: (data, textStatus, jqXHR) ->
        console.log("Children selected!")