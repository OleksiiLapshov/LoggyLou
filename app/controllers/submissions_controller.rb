class SubmissionsController < ApplicationController
  before_action :set_submission, only: %i[ show edit update destroy approve reject export ]
  before_action :require_admin, only: %i[ edit update destroy approve reject ]

  # GET /submissions or /submissions.json
  def index
    if current_user_admin?
      @submissions = Submission.all
    else
      @submissions = current_user.submissions
    end
  end

  # GET /submissions/1 or /submissions/1.json
  def show
  end

  # GET /submissions/new
  def new
    @submission = Submission.new
  end

  # GET /submissions/1/edit
  def edit
    @submission.note = nil
  end

  # POST /submissions or /submissions.json
  def create
    @submission = Submission.new(submission_params)

    respond_to do |format|
      if @submission.save
        format.html { redirect_to @submission, notice: "Submission was successfully created." }
        format.json { render :show, status: :created, location: @submission }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /submissions/1 or /submissions/1.json
  def update
    respond_to do |format|
      if @submission.update(submission_params)
        @submission.status = :rejected
        format.html { redirect_to @submission, notice: "Submission was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @submission }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /submissions/1 or /submissions/1.json
  def destroy
    @submission.destroy!

    respond_to do |format|
      format.html { redirect_to submissions_path, notice: "Submission was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
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
