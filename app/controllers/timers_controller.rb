class TimersController < ApplicationController
	before_action :set_timer, only:[:show]

	def show
	end

	private
		def set_timer
			if user_signed_in?
				@timer = current_user.timer
			else
				@timer = Timer.find(1)
			end
		end
end