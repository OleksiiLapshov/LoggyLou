class WorklogsController < ApplicationController

  before_action :require_signin
  before_action :set_worklog, only: %i[ show edit update destroy ]
  skip_before_action :set_worklog, only: :submit_timesheet
  before_action :set_projects, only: %i[ new create edit update ]

  # GET /worklogs or /worklogs.json
  def index
    @selected_month = params[:month]&.to_i || Date.today.month
    @selected_year = params[:year]&.to_i || Date.today.year

    selected_date = Date.new(@selected_year, @selected_month, 1)
    if current_user_admin?
      @worklogs = Worklog.where(log_date: selected_date.all_month).order(log_date: :desc)
    else
      @worklogs = current_user.worklogs.where(log_date: selected_date.all_month).order(log_date: :desc)
    end
  end

  # GET /worklogs/1 or /worklogs/1.json
  def show
  end

  # GET /worklogs/new
  def new
    @worklog = Worklog.new(log_date: Time.zone.today)
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
        format.html { redirect_to worklogs_url, notice: "Worklog was successfully created." }
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

  def export
    @selected_month = params[:month]&.to_i || Date.today.month
    @selected_year = params[:year]&.to_i || Date.today.year

    selected_date = Date.new(@selected_year, @selected_month, 1)

    if current_user_admin?
      @worklogs = Worklog.where(log_date: selected_date.all_month).order(log_date: :asc)
    else
      @worklogs = current_user.worklogs.where(log_date: selected_date.all_month).order(log_date: :asc)
    end

    respond_to do |format|
      format.csv do
        send_data generate_csv(@worklogs), 
                  filename: "worklogs_#{@selected_year}_#{@selected_month.to_s.rjust(2, '0')}.csv",
                  type: "text/csv",
                  disposition: "attachment"
      end
    end
  end

  def submit_timesheet
      month = params[:month]&.to_i || Date.today.month
      year = params[:year]&.to_i || Date.today.year

      period_start = Date.new(year, month, 1)
      period_end   = period_start.end_of_month

      # get worklogs for filtered period, and not submitted
      worklogs = current_user.worklogs
                        .for_period(period_start, period_end)
                        .not_submitted

      # Check if no worklogs to submit
      if worklogs.empty?
        redirect_to worklogs_path(month: month, year: year),
          alert: "No unsubmitted worklogs for #{period_start.strftime('%B %Y')}."
        return
      end

      # Check if there is a submission for this period
      if current_user.submissions.exists?(period_start: period_start, period_end: period_end)
        redirect_to worklogs_path(month: month, year: year),
                alert: "Already submitted for #{period_start.strftime('%B %Y')}."
        return
      end

      submission = current_user.submissions.create!(
        period_start: period_start,
        period_end:   period_end,
        status:       :draft,
        note:         "Submitted #{worklogs.sum(:hours)} hours for #{period_start.strftime('%B %Y')}"
      )
      worklogs.update_all(submission_id: submission.id)

      redirect_to submissions_path,
              notice: "Timesheet submitted for #{period_start.strftime('%B %Y')}!"
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

    def generate_csv(worklogs)
      require 'csv'

      CSV.generate(headers: true) do |csv|
        csv << [ "Date", "Employee", "Hours", "Notes", "Project", "Company" ]

        worklogs.each do |worklog|
          csv << [
            worklog.log_date.strftime("%Y-%m-%d"),
            worklog.user.full_name,
            worklog.hours.to_s,
            worklog.note,
            worklog.project.name,
            worklog.project.company
          ]
        end

        csv << []
        csv << [ "TOTAL", "", worklogs.sum(:hours).to_s, "", "", "" ]
      end
    end
end
