sortable = () ->
  $('#tasks').sortable({
    axis: 'y',
    update: ->
      $.ajax({
        type: 'POST',
        url: '/tasks/sort',
        dataType: 'json',
        data: $('#tasks').sortable('serialize'),
        success: () ->
          $('li').each (index) ->
            $(@).attr('id', "position_#{index}")
        })
    })
  $('#tasks').disableSelection()

$(document).on 'ready turbolinks:load', () ->
  unless $('.ui-sortable').length
    sortable()
    $('#task-form').on 'ajax:success', (e,data,status,xhr) ->
      $('#tasks').append("<li id=position_" +data["position"]+ " class=list-group-item>" +data["content"]+ '</li>')
      $('#task_content').val("")
      sortable()