class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_today_diary

  private
    def set_today_diary
      if user_signed_in?
        @today_diary = current_user.diaries.where(created_at: Time.now.all_day).first_or_create
      end
    end
end