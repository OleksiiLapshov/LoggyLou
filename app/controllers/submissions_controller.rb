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
      @submissions = Submission.where(period_start: first_day.all_month).order(created_at: :desc)
    else
      @submissions = current_user.submissions.where(period_start: first_day.all_month).order(created_at: :desc)
    end
  end

  # GET /submissions/1 or /submissions/1.json
  def show
    @project_hours = @submission.worklogs
                              .joins(:project)
                              .group("projects.name")
                              .sum(:hours)

    worklogs = @submission.worklogs.order(log_date: :desc)

    # Building the hash manually to ensure all dates are included (DO NOT USE groupdate, for some reason it ignores day 1)
    date_range = (@submission.period_start..@submission.period_end).to_a
    hours_by_date = worklogs.group(:log_date).sum(:hours)

    @worklogs_by_day = date_range.each_with_object({}) do |date, hash|
      hash[date] = hours_by_date[date] || 0
    end
  end

  def reject
    if params[:note].present?
      @submission.update(status: :rejected, note: params[:note])
      @submission.worklogs.update(submission_id: nil)
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
    respond_to do |format|
      format.csv do
        send_data generate_csv(@submission.worklogs),
                  filename: "worklogs_#{@submission.period_start}_#{@submission.period_end}.csv",
                  type: "text/csv",
                  disposition: "attachment"
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_submission
      @submission = Submission.find(params.expect(:id))
      unless current_user_admin? || @submission.user_id == current_user.id
        redirect_to submissions_path, alert: "You are not authorized to view this submission."
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
