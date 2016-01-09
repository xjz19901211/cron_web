class TasksController < ApplicationController
  before_action :set_work, only: [:index, :create]

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = @work.tasks.all
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @task = Task.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = @work.run

    redirect_to @task, notice: 'Task was successfully created.'
  end


  private

  def set_work
    @work = Work.find(params[:work_id])
  end
end

