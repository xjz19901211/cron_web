class WorksController < ApplicationController
  before_action :set_work, only: [:show, :edit, :update, :destroy]

  # GET /works
  # GET /works.json
  def index
    @works = Work.all
    if params[:q].present?
      str = params[:q].gsub('%', '')
      @works = @works.where("name like ?", "%#{str}%")
    end

    if params[:choice_view].present?
      render :choice_view
    else
      render :index
    end
  end

  # GET /works/1
  # GET /works/1.json
  def show
  end

  # GET /works/new
  def new
    @work = Work.new
  end

  # GET /works/1/edit
  def edit
  end

  # POST /works
  # POST /works.json
  def create
    @work = Work.new(work_params)
    @work.user = current_user

    respond_to do |format|
      if @work.save
        create_action_user_log(id: @work.id)
        format.html { redirect_to @work, notice: 'Work was successfully created.' }
        format.json { render :show, status: :created, location: @work }
      else
        format.html { render :new }
        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /works/1
  # PATCH/PUT /works/1.json
  def update
    respond_to do |format|
      if @work.update(work_params)
        create_action_user_log(id: @work.id)
        format.html { redirect_to @work, notice: 'Work was successfully updated.' }
        format.json { render :show, status: :ok, location: @work }
      else
        format.html { render :edit }
        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /works/1
  # DELETE /works/1.json
  def destroy
    create_action_user_log(id: @work.id)
    @work.destroy
    respond_to do |format|
      format.html { redirect_to works_url, notice: 'Work was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def set_work
    @work = Work.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def work_params
    params.require(:work).permit(
      :name, {input_args: [:key, :val]}, :code_lang, :code
    ).tap do |attrs|
      format_input_args(attrs)
    end
  end

  def format_input_args(attrs)
    # [{key: 'a', val: 'b'}]
    attrs[:input_args] ||= []
    attrs[:input_args] = attrs[:input_args].each_with_object({}) do |hash, result|
      next if hash['key'].blank?
      result[hash['key'].strip] = hash['val']
    end
  end
end
