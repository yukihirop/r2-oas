class Api::V1::TasksController < ApplicationController
  before_action :set_api_v1_task, only: [:show, :edit, :update, :destroy]

  # GET /api/v1/tasks
  # GET /api/v1/tasks.json
  def index
    @api_v1_tasks = Api::V1::Task.all
  end

  # GET /api/v1/tasks/1
  # GET /api/v1/tasks/1.json
  def show
  end

  # GET /api/v1/tasks/new
  def new
    @api_v1_task = Api::V1::Task.new
  end

  # GET /api/v1/tasks/1/edit
  def edit
  end

  # POST /api/v1/tasks
  # POST /api/v1/tasks.json
  def create
    @api_v1_task = Api::V1::Task.new(api_v1_task_params)

    respond_to do |format|
      if @api_v1_task.save
        format.html { redirect_to @api_v1_task, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @api_v1_task }
      else
        format.html { render :new }
        format.json { render json: @api_v1_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /api/v1/tasks/1
  # PATCH/PUT /api/v1/tasks/1.json
  def update
    respond_to do |format|
      if @api_v1_task.update(api_v1_task_params)
        format.html { redirect_to @api_v1_task, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @api_v1_task }
      else
        format.html { render :edit }
        format.json { render json: @api_v1_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api/v1/tasks/1
  # DELETE /api/v1/tasks/1.json
  def destroy
    @api_v1_task.destroy
    respond_to do |format|
      format.html { redirect_to api_v1_tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_v1_task
      @api_v1_task = Api::V1::Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def api_v1_task_params
      params.require(:api_v1_task).permit(:status, :content)
    end
end
