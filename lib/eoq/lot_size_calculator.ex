defmodule Eoq.LotSizeCalculator do
  alias Eoq.Inventory

  use GenServer

  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def trigger(product_id) do
    GenServer.cast(__MODULE__, {:trigger, product_id})
  end

  def init(_) do
    start_timer()
    {:ok, []}
  end

  def handle_info(:run, state) do
    products = Inventory.all_products()

    Enum.each(products, fn product ->
      run(product)
    end)

    start_timer()
    {:noreply, state}
  end

  def handle_cast({:trigger, product_id}, state) do
    IO.inspect "Here"
    product = Inventory.get_product_with_latest_param!(product_id)
    run(product)
    {:noreply, state}
  end

  defp start_timer do
    Process.send_after(self(), :run, 5 * 60000)
  end

  def run(product) do
    orders = Inventory.last_month_orders(product)
    service_level = product.service_level || 95
    review_time_days = product.review_time_days || 7
    lead_time_days = product.lead_time_days || 1

    # calculate z factor corresponding to confidence level in normal distribution
    z = Statistics.Distributions.Normal.ppf().(service_level/100)

    quantities = Enum.map(orders, & &1.quantity)
    mean = Statistics.mean(quantities) || 0
    std = Statistics.stdev(quantities) || 0
    total_time = review_time_days + lead_time_days
    eoq = round(mean * total_time + z * std * Statistics.Math.sqrt(total_time))
    save_params(product, eoq, round(mean))
  end

  def save_params(product, eoq, demand) do
    case product.product_params do
      [product_param] ->
        if product_param.demand_daily != demand do
          Inventory.update_product_param!(%{demand_daily: demand, lot_size: eoq}, product_param.id)
          EoqWeb.Endpoint.broadcast!("products:lobby", "new_msg", %{product_id: product.id, demand_daily: demand, lot_size: eoq})
          Logger.info("Product param #{product_param.id} updated with eoq #{eoq}, demand #{demand}")
        end
      _ ->
        :ok
    end
  end
end
