class TimersController < ApplicationController
	before_action :set_timer, only:[:show]

	def show
	end

	def create
		if Timer.where(user_id: current_user.id).length > 0
			@timer = current_user.timer
		else
			@timer = current_user.build_timer
		end
		minutes_to_seconds
		@timer.save
		redirect_to root_path
	end

	private
		def set_timer
			if user_signed_in?
				if Timer.where(user_id: current_user.id).length > 0
					@timer = current_user.timer
				else
					@timer = Timer.find(1)
				end
			else
				@timer = Timer.find(1)
			end
		end

		def timer_params
			params.require(:timer).permit(:pomodoro, :short_rest, :long_rest)
		end

		def minutes_to_seconds
			@timer.pomodoro = params[:timer][:pomodoro].to_i * 60
			@timer.short_rest = params[:timer][:short_rest].to_i * 60
			@timer.long_rest = params[:timer][:long_rest].to_i * 60
		end
end