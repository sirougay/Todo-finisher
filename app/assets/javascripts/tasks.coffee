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
      $('#tasks').append('<li id=position_' +data["position"]+ ' class=list-group-item>'+
        '<h4 class="list-group-item-heading" data-task-id='+data["id"]+'>' +data["content"]+ '</h4>'+
        '<p class="list-group-item-text"><a class="edit-task" href="#">編集</a>'+
        '<a data-confirm="本当に削除しますか？" rel="nofollow" data-method="delete" href=/tasks/'+data["id"]+'> 削除</a>'+
        '<a data-confirm="かかった時間を記録できませんが、完了しますか？" rel="nofollow" data-method="patch" href=/tasks/'+data["id"]+'/done> Done</a></p></li>')
      $('#task_content').val("")
      sortable()

$(document).on 'click', '.edit-task', () ->
  target = $(this).parents('li').children('h4')
  content = target.text()
  target.addClass('input-group')
  target.html('<input type="text" id="editing-task" onchange="editTaskContent()" class="form-control" value=' + content + '>')
  return false

window.editTaskContent = () ->
  target = $('#editing-task').parent()
  content = $('#editing-task').val()
  console.log(target.data('task-id'))
  $.ajax({
    type: 'PATCH',
    url: '/tasks/'+target.data('task-id'),
    dataType: 'json',
    data: {"content": content},
    success: () ->
      $('#editing-task').remove()
      target.text(content)
    })
