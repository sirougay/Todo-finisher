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
          $('.sortable-item').each (index) ->
            $(@).attr('id', "position_#{index}")
        })
    })
  $('#tasks').disableSelection()

$(document).on 'ready turbolinks:load', () ->
  unless $('.ui-sortable').length
    sortable()
    $('#task-form').on 'ajax:success', (e,data,status,xhr) ->
      $('#tasks').append('<li id=position_' +data["position"]+ ' class=list-group-item><h4 class="list-group-item-heading">' +data["content"]+ 
        '</h4><p class="list-group-item-text"><a data-confirm="本当に削除しますか？" rel="nofollow" data-method="delete" href=/tasks/'+data["id"]+'>削除</a>'+
        ' <a data-confirm="かかった時間を記録できませんが、完了しますか？" rel="nofollow" data-method="patch" href=/tasks/'+data["id"]+'/done>完了</a></p></li>')
      $('#task_content').val("")
      sortable()