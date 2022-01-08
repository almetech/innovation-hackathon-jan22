defmodule Eoq.LotSizeCalculator do
  alias Eoq.Inventory

  def run(product) do
    orders = Inventory.last_month_orders(product)
    service_level = 95

    # calculate z factor corresponding to confidence level in normal distribution
    z = Statistics.Distributions.Normal.ppf().(service_level/100)

    quantities = Enum.map(orders, & &1.quantity)
    mean = Statistics.mean(quantities)
    std = Statistics.stdev(quantities)
    total_time = product.review_time_days + product.lead_time_days
    eoq = round(mean * total_time + z * std * Statistics.Math.sqrt(total_time))

    IO.inspect mean
    IO.inspect std
    IO.inspect eoq
  end
end
