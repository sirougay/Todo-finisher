class TasksController < ApplicationController
	before_action :authenticate_user!
	before_action :set_tasks, only:[:index, :sort, :create]
	before_action :set_task, only:[:destroy, :done, :done_at_timer]

	def index
		@task = Task.new
	end

	def sort
		ids = []
		position_numbers = params[:position]
		position_numbers.each_with_index do |num, i|
			num = num.to_i
			task = @tasks.where.not(id: ids).find_by(position: num)
			task.position = i
			task.save
			ids << task.id
		end
		render json: {}
	end

	def create
		@task = current_user.tasks.new(task_params)
		@task.status = false
		@task.position = @tasks.last.position + 1
		@task.save
		render json: {content: @task.content, position: @task.position, id: @task.id}
	end

	def destroy
		@task.destroy
		redirect_to tasks_path
	end

	def done
		diary = current_user.diaries.where(created_at: Time.now.all_day).first_or_create
		@task.diary_id = diary.id
		@task.status = true
		@task.save
		redirect_to tasks_path
	end

	def done_at_timer
		diary = current_user.diaries.where(created_at: Time.now.all_day).first_or_create
		@task.diary_id = diary.id
		@task.status = true
		@task.spent_time = params[:spent_time]
		@task.save
		task = current_user.tasks.where(status: false).order(:position).first
		render json: {content: task.content, id: task.id}
	end

	private
		def task_params
			params.require(:task).permit(:content)
		end

		def set_tasks
			@tasks = current_user.tasks.where(status: false).order(:position)
		end

		def set_task
			@task = current_user.tasks.find(params[:id])
		end
end
