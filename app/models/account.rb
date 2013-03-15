class Account < Connection::Sinensup
  set_table_name  'CUENTAS'
  set_primary_key :ID
  alias_attribute :value, :importe

  belongs_to :account_plan, foreign_key: :ID_plan_de_cuentas_unificado

  def self.values codes
    values = Hash.new
    codes.each do |description, code|
      values[description] = where(ID_codigo: Code.find_by_codigo_completo(code).id).inject(0) do |sum, account|
        sum + account.value
      end
    end
    OpenStruct.new(values).marshal_dump
  end
end
