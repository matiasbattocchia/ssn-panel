# encoding: utf-8

class CompaniesController < ApplicationController

  def index
    @companies = Company.order :CiaId
    render layout: 'application'
  end

  def company
    @company     = Company.find params[:id]
    @branches    = @company.branches.where Fecha_Baja: nil, Tipo: 'S'
    @agencies    = @company.branches.where Fecha_Baja: nil, Tipo: 'A'
    @president   = @company.directors.where(Funcion_DL: 'Presidente').order(:DirectorioID).last
    @shareholder = @company.shareholders.order(:AccionistasID, :Participacion).last
  end

  def headquarters
    @company = Company.find params[:id]
  end
  
  def branches
    @company  = Company.find params[:id]
    @branches = @company.branches.where Fecha_Baja: nil, Tipo: 'S'
    render locals: { title: 'Sucursales', branches: @branches }
  end
  
  def agencies
    @company  = Company.find params[:id]
    @agencies = @company.branches.where Fecha_Baja: nil, Tipo: 'A'
    render locals: { title: 'Agencias', branches: @agencies }, template: 'companies/branches'
  end
  
  def directors
    @company           = Company.find params[:id]
    @last_presentation = @company.directors.maximum :DirectorioID
    @presentation      = params[:presentation] || @last_presentation
    @directors         = @company.directors.where DirectorioID: @presentation
  end
  
  def shareholders
    @company           = Company.find params[:id]
    @last_presentation = @company.shareholders.maximum :AccionistasID
    @presentation      = params[:presentation] || @last_presentation
    @shareholders      = @company.shareholders.where AccionistasID: @presentation
  end

  def assets
    codes = { 'Disponibilidades' => '1.01.00.00.00.00.00.00',
              'Inversiones'      => '1.02.00.00.00.00.00.00',
              'Créditos'         => '1.03.00.00.00.00.00.00',
              'Inmuebles'        => '1.04.00.00.00.00.00.00',
              'Bienes de uso'    => '1.05.00.00.00.00.00.00',
              'Otros activos'    => '1.06.00.00.00.00.00.00',
              'Total activo'     => '1.00.00.00.00.00.00.00' }

    @company   = Company.find params[:id]
    @period    = params[:period] || '2011-4'
    #@frequency = params[:frecuency] || 'Trimestral'
    @accounts  = @company.account_plan(@period).accounts.values(codes)
  end
end
