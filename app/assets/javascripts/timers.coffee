updateTimer = () ->
  TimeoutId = setTimeout ->
    t = Date.now() - window.startTime
    if (t/1000) >= 60
      min = Math.floor( (t/1000)/60 )
      sec = Math.floor( (t/1000)- min*60 )
      $("#timerText").html("#{min}分 #{sec}秒")
    else
    	$("#timerText").html( Math.floor(t / 1000)+ "秒" )
    updateTimer()
  , 100
  $(document).on 'click', '#stop' , () ->
  	clearTimeout(TimeoutId)
  	if window.stopTime is undefined
  		window.stopTime = Date.now()
  $(document).on 'click', '#reset' , () ->
  	resetTimer()
  	clearTimeout(TimeoutId)

resetTimer = () ->
	window.startTime = undefined
	window.stopTime = undefined
	$("#timerText").html("0秒")

$(document).on 'click', '#start' , () ->
	if window.startTime is undefined
  	window.startTime = Date.now()
  else if window.stopTime is undefined
  else
  	window.startTime = window.startTime + (Date.now() - window.stopTime)
  	window.stopTime = undefined
  updateTimer()