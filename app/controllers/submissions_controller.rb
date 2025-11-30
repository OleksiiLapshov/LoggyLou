class SubmissionsController < ApplicationController
  before_action :require_signin
  before_action :set_submission, only: %i[ show approve reject export ]
  before_action :require_admin, only: %i[ approve reject ]

  # GET /submissions or /submissions.json
  def index
    @selected_month = params[:month].presence&.to_i || Date.today.month
    @selected_year = params[:year].presence&.to_i || Date.today.year

    first_day = Date.new(@selected_year, @selected_month, 1)

    if current_user_admin?
      @submissions = Submission.includes(:user, :worklogs).where(period_start: first_day.all_month).order(created_at: :desc)
    else
      @submissions = current_user.submissions.includes(:worklogs).where(period_start: first_day.all_month).order(created_at: :desc)
    end
  end

  # GET /submissions/1 or /submissions/1.json
  def show
    @project_hours = @submission.worklogs
                              .joins(:project)
                              .group("projects.name")
                              .sum(:hours)

    @projects = @submission.worklogs
                          .joins(:project)
                          .select("projects.id, projects.name").distinct

    @worklogs = @submission.worklogs.includes(:project, :user).order(log_date: :asc)

    @worklogs_by_day = @submission.chart_data
  end

  def reject
    if params[:note].present?
      @submission.update(status: :rejected, note: params[:note])
      @submission.worklogs.update_all(submission_id: nil)
      redirect_to @submission, notice: "Submission rejected."
    else
      redirect_to @submission, alert: "Please provide a rejection note."
    end
  end

  def approve
    @submission.update(status: :approved)
    redirect_to @submission, notice: "Submission approved."
  end

  def export
    @worklogs_to_export = @submission.worklogs.includes(:user, :project)
    filename_addition = "_all"

    if params[:project_id].present?
      project = Project.find(params[:project_id])

      if project
        @worklogs_to_export = @worklogs_to_export.where(project_id: params[:project_id])
        filename_addition = "_#{project.name.parameterize}"
      end
    end

    filename = "worklogs_#{@submission.user.full_name}_#{@submission.period_start}_#{@submission.period_end}_#{filename_addition}"

    respond_to do |format|
      format.csv do
        send_data generate_csv(@worklogs_to_export),
                  type: "text/csv",
                  disposition: "attachment",
                  filename: "#{filename}.csv"
      end

      format.xlsx do
        render xlsx: "export", filename: "#{filename}.xlsx"
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_submission
      if current_user_admin?
        @submission = Submission.find(params.expect(:id))
      else
        @submission = current_user.submissions.find(params.expect(:id))
      end
    end

    # Only allow a list of trusted parameters through.
    def submission_params
      params.expect(submission: [ :user_id, :period_start, :period_end, :status, :note ])
    end

    def generate_csv(worklogs)
      require 'csv'

      CSV.generate(headers: true) do |csv|
        csv << [ "Date", "Employee", "Hours", "Notes", "Project", "Company" ]

        worklogs.order(:log_date).each do |worklog|
          csv << [
            worklog.log_date.strftime("%Y-%m-%d"),
            worklog.user.full_name,
            worklog.hours.to_s,
            worklog.note.gsub(/\R+/, " "),
            worklog.project.name,
            worklog.project.company
          ]
        end

        csv << []
        csv << [ "TOTAL", "", worklogs.sum(:hours).to_s, "", "", "" ]
      end
    end
end
