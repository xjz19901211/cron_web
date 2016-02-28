class TasksController < ApplicationController
  before_action :set_work, only: [:index, :create]
  before_action :set_task, only: [:show, :start_code, :run_code]

  skip_before_action :check_user_filter, only: [:start_code, :run_code]

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = @work.tasks.all.order(updated_at: :desc)
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  def start_code
    render :start_code, layout: false, content_type: 'text/plain'
  end

  def run_code
    render text: @task.run_code, layout: false, content_type: 'text/plain'
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = @work.tasks.create!(user: current_user)
    CodeWorker.new(@task).perform
    create_action_user_log(id: @task.id)

    redirect_to @task, notice: 'Task was successfully created.'
  end


  private

  def set_work
    @work = Work.find(params[:work_id])
  end

  def set_task
    @task = Task.find(params[:id])
  end
end

