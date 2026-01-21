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
    @company = Company.new
  end

  def edit
    @company = Company.find(params.expect(:id))
  end

  def create
    @company = Company.new(company_params)

    if @company.save
      redirect_to companies_url, notice: "Company was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @company = Company.find(params.expect(:id))
    if @company.update(company_params)
      redirect_to companies_url, notice: "Company was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def company_params
    params.expect(company: [
      :name,
      :address_line_1,
      :address_line_2,
      :postcode,
      :city,
      :country,
      :vat,
      :account_number,
      :contact_phone,
      :contact_email,
      :contact_person
    ])
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
