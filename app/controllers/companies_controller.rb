class CompaniesController < ApplicationController
  before_action :require_signin
  before_action :require_admin
  before_action :set_company, only: %i[ show edit update ]
  def index
    @companies = Company.includes(:projects)
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to @company, notice: "Company details were successfully updated.", status: :see_other }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

private
    def set_company
      @company = Company.find(params.expect(:id))
    end

    def company_params
      params.expect(company: [ :name, :address_line_1, :address_line_2,
                               :postcode, :city, :country, :vat, :account_number,
                               :contact_phone, :contact_email, :contact_person ])
    end
end
