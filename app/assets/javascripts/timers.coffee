stopTimer = (TimeoutId) ->
  window.stopTime = Date.now()
  clearTimeout(TimeoutId)
  #一時停止ボタンを再開ボタンにする
  $('#stop').html("再開")
  $('#stop').attr('id', "start")

resetTimer = (TimeoutId) ->
  window.startTime = undefined
  window.stopTime = undefined
  clearTimeout(TimeoutId)
  if $('#stop').length
    $('#stop').html("開始！")
    $('#stop').attr('id', "start")

pomodoroTimer = () ->
  TimeoutId = setTimeout ->
    t = (Date.now() - window.startTime) / 1000
    remainingTime = window.pomodoro - t
    if remainingTime >= 60
      min = Math.floor( remainingTime / 60 )
      sec = Math.floor( remainingTime - min*60 )
      $('#timerText').html("#{min}分 #{sec}秒")
      pomodoroTimer()
    else if remainingTime > 0
      $('#timerText').html( Math.floor(remainingTime)+ "秒" )
      pomodoroTimer()
    else if remainingTime <= 0
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
  , 100
  $(document).on 'click', '#stop' , () ->
    stopTimer(TimeoutId)
  $(document).on 'click', '#reset' , () ->
    resetTimer(TimeoutId)
    $('#timerText').html((window.pomodoro / 60) + "分")

shortRestTimer = () ->
  TimeoutId = setTimeout ->
    t = (Date.now() - window.startTime) / 1000
    remainingTime = window.shortRest - t
    if remainingTime >= 60
      min = Math.floor( remainingTime / 60 )
      sec = Math.floor( remainingTime - min*60 )
      $('#timerText').html("#{min}分 #{sec}秒")
      shortRestTimer()
    else if remainingTime > 0
      $('#timerText').html( Math.floor(remainingTime)+ "秒" )
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

longRestTimer = () ->
  TimeoutId = setTimeout ->
    t = (Date.now() - window.startTime) / 1000
    remainingTime = window.longRest - t
    if remainingTime >= 60
      min = Math.floor( remainingTime / 60 )
      sec = Math.floor( remainingTime - min*60 )
      $('#timerText').html("#{min}分 #{sec}秒")
      longRestTimer()
    else if remainingTime > 0
      $('#timerText').html( Math.floor(remainingTime)+ "秒" )
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

$(document).on 'click', '#start' , () ->
  # 開始ボタンを押されたとき
  if window.startTime is undefined
    window.startTime = Date.now()
  # ストップボタンを押されてタイマー停止中に、再開ボタンを押されたとき
  else
    window.startTime = window.startTime + (Date.now() - window.stopTime)
    window.stopTime = undefined
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

$(document).on 'ready', () ->
  window.pomodoro = $('#timerStatus').data('pomodoro')
  window.shortRest =  $('#timerStatus').data('short-rest')
  window.longRest = $('#timerStatus').data('long-rest')
  window.pomodoroCount = 0
  window.restAudio = new Audio('/assets/se_maoudamashii_onepoint26.wav')
  window.startAudio = new Audio('/assets/se_maoudamashii_system23.wav')
  $('#timerStatus').html("作業を始めよう！")

$(document).on 'click', '#end', () ->
  # メッセージを出して画面遷移させる。
  $.ajax({
    url: 'lists/index'
    type: 'GET'
    })
  window.location.href = 'http://localhost:3000/'