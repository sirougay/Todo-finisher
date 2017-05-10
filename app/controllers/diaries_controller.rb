class DiariesController < ApplicationController
  before_action :authenticate_user!

  def new
  end
  
  def show
    @diary = Diary.find(params[:id])
  end

  def index
    @diaries = current_user.diaries
  end
end