module PaidCommissionHelper
  def period_desc(start_date, end_date)
    "De: #{start_date == '' ? 'primeiro dado disponível' : start_date.strftime('%d/%m/%Y')} " \
      "até: #{end_date == '' ? 'último dado disponível' : end_date.strftime('%d/%m/%Y')}"
  end
end
