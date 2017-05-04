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
    clearTimeout(TimeoutId)
  	if window.stopTime is undefined
      window.stopTime = Date.now()
  $(document).on 'click', '#reset' , () ->
    window.startTime = undefined
    window.stopTime = undefined
    $('#timerText').html(window.pomodoro + "分")
    clearTimeout(TimeoutId)

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
      clearTimeout(TimeoutId)
      $('#timerStatus').html("作業中")
      $('#timerStatus').removeClass("short-rest")
      $('#timerStatus').addClass("pomodoro-now")
      pomodoroTimer()
  , 100
  $(document).on 'click', '#stop' , () ->
    clearTimeout(TimeoutId)
    if window.stopTime is undefined
      window.stopTime = Date.now()
  $(document).on 'click', '#reset' , () ->
    window.startTime = undefined
    window.stopTime = undefined
    $('#timerText').html(window.shortRest + "分")
    clearTimeout(TimeoutId)

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
      clearTimeout(TimeoutId)
      $('#timerStatus').html("作業中")
      $('#timerStatus').removeClass("long-rest")
      $('#timerStatus').addClass("pomodoro-now")
      pomodoroTimer()
  , 100
  $(document).on 'click', '#stop' , () ->
    clearTimeout(TimeoutId)
    if window.stopTime is undefined
      window.stopTime = Date.now()
  $(document).on 'click', '#reset' , () ->
    window.startTime = undefined
    window.stopTime = undefined
    $('#timerText').html(window.shortRest + "分")
    clearTimeout(TimeoutId)

$(document).on 'click', '#start' , () ->
  # スタートボタンを初めて押されたとき
	if window.startTime is undefined
  	window.startTime = Date.now()
  # ストップボタンを押されずにスタートボタンを押されたとき
  else if window.stopTime is undefined
  # ストップボタンを押されてタイマーが停止中のとき
  else
  	window.startTime = window.startTime + (Date.now() - window.stopTime)
  	window.stopTime = undefined
  if $('#timerStatus.short-rest').length
    shortRestTimer()
  else if $('#timerStatus.long-rest').length
    longRestTimer()
  else
    $('#timerStatus').html("作業中")
    $('#timerStatus').addClass("pomodoro-now")
    pomodoroTimer()

$(document).on 'ready', () ->
  window.pomodoro = $('#timerStatus').data('pomodoro')
  window.shortRest = $('#timerStatus').data('short-rest')
  window.longRest = $('#timerStatus').data('long-rest')
  window.pomodoroCount = 0
  $('#timerStatus').html("startボタンで作業開始！")