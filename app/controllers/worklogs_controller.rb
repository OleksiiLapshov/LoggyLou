class WorklogsController < ApplicationController

  before_action :require_signin
  before_action :set_worklog, only: %i[ show edit update destroy ]
  before_action :set_projects, only: %i[ new create edit update ]

  # GET /worklogs or /worklogs.json
  def index
    @selected_month = params[:month]&.to_i || Date.today.month
    @selected_year = params[:year]&.to_i || Date.today.year

    selected_date = Date.new(@selected_year, @selected_month, 1)
    if current_user_admin?
      @worklogs = Worklog.where(log_date: selected_date.all_month).order(log_date: :asc)
    else
      @worklogs = current_user.worklogs.where(log_date: selected_date.all_month).order(log_date: :asc)
    end
  end

  # GET /worklogs/1 or /worklogs/1.json
  def show
  end

  # GET /worklogs/new
  def new
    @worklog = Worklog.new
  end

  # GET /worklogs/1/edit
  def edit
  end

  # POST /worklogs or /worklogs.json
  def create
    @worklog = Worklog.new(worklog_params)
    @worklog.user = current_user

    respond_to do |format|
      if @worklog.save
        format.html { redirect_to @worklog, notice: "Worklog was successfully created." }
        format.json { render :show, status: :created, location: @worklog }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @worklog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /worklogs/1 or /worklogs/1.json
  def update
    respond_to do |format|
      if @worklog.update(worklog_params)
        format.html { redirect_to @worklog, notice: "Worklog was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @worklog }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @worklog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /worklogs/1 or /worklogs/1.json
  def destroy
    @worklog.destroy!

    respond_to do |format|
      format.html { redirect_to worklogs_path, notice: "Worklog was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_worklog
      @worklog = Worklog.find(params.expect(:id))
    end

    def set_projects
      @projects = current_user.projects
    end

    # Only allow a list of trusted parameters through.
    def worklog_params
      params.expect(worklog: [ :hours, :note, :log_date, :project_id ])
    end
end
