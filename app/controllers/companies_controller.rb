class CompaniesController < ApplicationController
  before_action :require_signin
  before_action :require_admin
  def index
    @companies = Company.includes(:projects)
  end

  def show
    @company = Company.find(params.expect(:id))
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
  end
end
