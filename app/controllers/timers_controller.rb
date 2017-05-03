class TimersController < ApplicationController
	def show
		if user_signed_in?
			@timer.pomodoro = current_user.timer.pomodoro
		else
			@timer.pomodoro = 25
		end
	end
end