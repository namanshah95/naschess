# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).on 'change', '#lesson_group', (evt) ->
    $.ajax 'update_attendance',
      type: 'GET'
      dataType: 'script'
      data: {
        group: $("#lesson_group option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{errorThrown}")
      success: (data, textStatus, jqXHR) ->
        console.log("Group selected!")