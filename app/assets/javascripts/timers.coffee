stopTimer = (TimeoutId) ->
  window.stopTime = Date.now()
  clearTimeout(TimeoutId)
  #一時停止ボタンを再開ボタンにする
  $('#stop').html("再開")
  $('#stop').attr('id', "start")

resetTimer = (TimeoutId) ->
  window.startTime = undefined
  window.stopTime = undefined
  window.spentTime = 0
  clearTimeout(TimeoutId)
  if $('#stop').length
    $('#stop').html("開始！")
    $('#stop').attr('id', "start")

setRemainingTime = (status) ->
  # リセット後のturbolinksによる誤作動防止
  if window.startTime is undefined
    window.startTime = Date.now()
  t = (Date.now() - window.startTime) / 1000
  @remainingTime = status - t
  @min = Math.floor( @remainingTime / 60 )
  @sec = Math.floor( @remainingTime - min*60 )

pomodoroTimer = () ->
  TimeoutId = setTimeout ->
    window.spentTime += 500
    window.pomodoroTime += 500
    if window.pomodoroTime >= 60000
      console.log(window.pomodoroTime)
      $.ajax({
        type: 'POST',
        url: '/diaries/' + gon.today_diary.id + '/pomodoro',
        dataType: 'json',
        data: {"pomodoro_time": window.pomodoroTime},
        })
        .done( () ->
          console.log("success")
          window.pomodoroTime = 0
        ).fail () ->
          console.log("error")
          alert("ポモドーロを保存できませんでした")
          window.pomodoroTime = 0
    setRemainingTime(window.pomodoro)
    if @remainingTime >= 60
      $('#timerText').html("#{@min}分 #{@sec}秒")
      pomodoroTimer()
    else if @remainingTime > 0
      $('#timerText').html( "#{@sec}秒" )
      pomodoroTimer()
    else if @remainingTime <= 0
      window.startTime = Date.now()
      window.pomodoroCount += 1
      window.restAudio.play()
      clearTimeout(TimeoutId)
      if window.pomodoroCount % 4 is 0
        $('#timerStatus').html("大休憩")
        $('#timerStatus').removeClass("pomodoro-now")
        $('#timerStatus').addClass("long-rest")
        longRestTimer()
      else
        $('#timerStatus').html("小休憩")
        $('#timerStatus').removeClass("pomodoro-now")
        $('#timerStatus').addClass("short-rest")
        shortRestTimer()
  , 500
  $(document).on 'click', '#stop' , () ->
    stopTimer(TimeoutId)
  $(document).on 'click', '#reset' , () ->
    resetTimer(TimeoutId)
    $('#timerText').html((window.pomodoro / 60) + "分")
  $(document).on 'turbolinks:load', () =>
    if window.stopTime is undefined
      stopTimer(TimeoutId)
    $('#timerStatus').html("作業中")
    $('#timerStatus').addClass("pomodoro-now")
    $('#start').html("再開")
    $('#timerText').html("一時中断中")

shortRestTimer = () ->
  TimeoutId = setTimeout ->
    setRemainingTime(window.shortRest)
    if @remainingTime >= 60
      $('#timerText').html("#{@min}分 #{@sec}秒")
      shortRestTimer()
    else if remainingTime > 0
      $('#timerText').html( "#{@sec}秒" )
      shortRestTimer()
    else if remainingTime <= 0
      window.startTime = Date.now()
      window.startAudio.play()
      clearTimeout(TimeoutId)
      $('#timerStatus').html("作業中")
      $('#timerStatus').removeClass("short-rest")
      $('#timerStatus').addClass("pomodoro-now")
      pomodoroTimer()
  , 100
  $(document).on 'click', '#stop' , () ->
    stopTimer(TimeoutId)
  $(document).on 'click', '#reset' , () ->
    resetTimer(TimeoutId)
    $('#timerText').html(window.shortRest + "分")
  $(document).on 'turbolinks:load', () =>
    if window.stopTime is undefined
      stopTimer(TimeoutId)
    $('#timerStatus').html("小休憩")
    $('#timerStatus').addClass("short-rest")
    $('#start').html("再開")
    $('#timerText').html("一時中断中")

longRestTimer = () ->
  TimeoutId = setTimeout ->
    setRemainingTime(window.longRest)
    if @remainingTime >= 60
      $('#timerText').html("#{@min}分 #{@sec}秒")
      longRestTimer()
    else if remainingTime > 0
      $('#timerText').html( "#{@sec}秒" )
      longRestTimer()
    else if remainingTime <= 0
      window.startTime = Date.now()
      window.startAudio.play()
      clearTimeout(TimeoutId)
      $('#timerStatus').html("作業中")
      $('#timerStatus').removeClass("long-rest")
      $('#timerStatus').addClass("pomodoro-now")
      pomodoroTimer()
  , 100
  $(document).on 'click', '#stop' , () ->
    stopTimer(TimeoutId)
  $(document).on 'click', '#reset' , () ->
    resetTimer(TimeoutId)
    $('#timerText').html(window.longRest + "分")
  $(document).on 'turbolinks:load', () =>
    if window.stopTime is undefined
      stopTimer(TimeoutId)
    $('#timerStatus').html("大休憩")
    $('#timerStatus').addClass("long-rest")
    $('#start').html("再開")
    $('#timerText').html("一時中断中")

$(document).on 'click', '#start' , () ->
  # 開始ボタンを押されたとき
  if window.startTime is undefined
    window.startTime = Date.now()
  # タイマー停止中に再開ボタンを押されたとき
  else
    window.startTime = window.startTime + (Date.now() - window.stopTime)
  # 作動中のタイマーの種類によって分ける
  if $('#timerStatus.short-rest').length
    shortRestTimer()
  else if $('#timerStatus.long-rest').length
    longRestTimer()
  else
    $('#timerStatus').html("作業中")
    $('#timerStatus').addClass("pomodoro-now")
    window.startAudio.play()
    pomodoroTimer()
  # 開始ボタンを一時停止ボタンにする
  $('#start').html("一時停止")
  $('#start').attr('id', "stop")
  window.stopTime = undefined

$(document).on 'ready turbolinks:load', () ->
  #turbolinksによる二重動作の防止
  unless $('.ready').length
    $('#timerStatus').addClass("ready")
    $('#start').html("開始！")
    $('#timerStatus').html("作業を始めよう！")
    window.pomodoro = $('#timerStatus').data('pomodoro')
    window.shortRest =  $('#timerStatus').data('short-rest')
    window.longRest = $('#timerStatus').data('long-rest')
    window.pomodoroTime = 0
    window.restAudio = new Audio('/assets/se_maoudamashii_onepoint26.wav')
    window.startAudio = new Audio('/assets/se_maoudamashii_system23.wav')
    if window.spentTime is undefined
      window.spentTime = 0
    if gon.user_signed_in
      $('#current-task').append("現在のタスク: " + gon.task.content)
      $('#end').removeClass("hidden")

$(document).on 'click', '#end', () ->
  if gon.user_signed_in
    console.log(window.spentTime)
    $.ajax({
      url: '/tasks/'+gon.task.id+'/done_at_timer',
      type: 'POST',
      dataType: 'json',
      data: {
        "spent_time": window.spentTime
      }, 
      success: (data) ->
        $('#current-task').html("現在のタスク: " + data['content'])
        gon.task.id = data['id']
        window.spentTime = 0
      })