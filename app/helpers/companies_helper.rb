module CompaniesHelper
  def company_path(company)
    "/companies/#{company.id}"
  end
end
