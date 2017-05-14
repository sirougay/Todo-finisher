class DiariesController < ApplicationController
  before_action :authenticate_user!

  def new
  end
  
  def show
    @diary = Diary.find(params[:id])
    @tasks = @diary.tasks.where(status: true).order(:updated_at)
    @pomodoro = @diary.pomodoro_time % 60000
  end

  def index
    @diaries = current_user.diaries
  end

  def record_pomodoro
    @diary = Diary.find(params[:id])
    if @diary.pomodoro_time == nil
      @diary.pomodoro_time = params[:pomodoro_time].to_i
    else
      @diary.pomodoro_time = @diary.pomodoro_time + params[:pomodoro_time].to_i
    end
    @diary.save
    render json:{}
  end
end