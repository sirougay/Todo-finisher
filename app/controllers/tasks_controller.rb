class TasksController < ApplicationController
	before_action :authenticate_user!
	before_action :set_tasks, only:[:index, :sort, :create]

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
		render json: {status: 'success'}
	end

	def create
		@task = current_user.tasks.new(task_params)
		@task.status = false
		@task.position = @tasks.last.position + 1
		@task.save
		render json: {content: @task.content, position: @task.position}
	end

	def destroy
		@task = Task.find(params[:id])
		@task.destroy
		redirect_to tasks_path
	end

	private
		def task_params
			params.require(:task).permit(:content)
		end

		def set_tasks
			@tasks = current_user.tasks.order(:position)
		end
end
