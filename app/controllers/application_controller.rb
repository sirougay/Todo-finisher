class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_user

  private
    def set_user
      if user_signed_in?
        @today_diary = current_user.diaries.where(created_at: Time.now.all_day).first_or_create
        #Turbolinksによって値が失われないように、ここで定義する
        gon.task = current_user.tasks.where(status: false).order(:position).first
        gon.user_signed_in = true
      else
        gon.user_signed_in = false
      end
    end
end