defmodule Eoq.Calculator do
  alias Eoq.Inventory
  alias Statistics.Distributions.Normal

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
      Task.start fn ->
        run_for_product(product.id)
      end
    end)

    start_timer()
    {:noreply, state}
  end

  def handle_cast({:trigger, product_id}, state) do
    product = Inventory.get_product_with_latest_param!(product_id)

    Task.start(fn ->
      case product.product_params do
        [product_param] ->
          run(product_param)
        _ ->
          :ok
      end
    end)

    {:noreply, state}
  end

  defp start_timer do
    Process.send_after(self(), :run, 5 * 60000)
  end

  def run_for_product(product_id) do
    product = Inventory.get_product_with_latest_param!(product_id)
    run(List.first(product.product_params))
  end

  def run_all_sync do
    products = Inventory.all_products()

    Enum.each(products, fn product ->
      run_for_product(product.id)
    end)
  end

  def run(product_param) do
    orders = Inventory.last_month_orders(product_param.product_id)

    if orders != [] do
      do_run(product_param, orders)
    end
  end

  def do_run(product_param, orders) do
    service_level = (product_param.service_level || 95) / 100
    review_time_days = product_param.review_time_days || 7
    lead_time_days = product_param.lead_time_days || 1
    cost_holding = (product_param.cost_holding || 10) / 100 # Holding cost per day
    cost_holding_review_time = cost_holding * review_time_days / 30
    cost_stockout = (product_param.cost_stockout || 20) / 100
    cost_ordering = product_param.cost_ordering || 30

    quantities = Enum.map(orders, & &1.quantity)
    prices = Enum.map(orders, & &1.price)
    mean = Statistics.mean(quantities) || 0
    std = Statistics.stdev(quantities) || 0
    avg_price = Statistics.mean(prices) || 0

    # calculate the eoq as per periodic review formula and given service level, also the ideal service level and ideal cost
    inv_cost_holding = cost_holding_review_time * avg_price
    inv_cost_stockout = cost_stockout * avg_price
    x_std = std * Statistics.Math.sqrt(review_time_days + lead_time_days)
    total_time = review_time_days + lead_time_days

    z = z_factor(service_level)

    eoq = eoq(mean, total_time, z, std)
    eoq_cost = cost(inv_cost_holding, mean, review_time_days, z, x_std, cost_ordering, inv_cost_stockout)

    optimum_service_level = 1 - inv_cost_holding / inv_cost_stockout
    optimum_z = z_factor(optimum_service_level)
    optimum_eoq = eoq(mean, total_time, optimum_z, std)
    optimum_eoq_cost = cost(inv_cost_holding, mean, review_time_days, optimum_z, x_std, cost_ordering, inv_cost_stockout)

    params = %{
      demand_daily: round(mean),
      lot_size: eoq,
      cost: eoq_cost,
      optimum_service_level: round(optimum_service_level * 100),
      optimum_lot_size: optimum_eoq,
      optimum_cost: optimum_eoq_cost,
      price: avg_price
    }

    save_params(product_param, params)
  end

  defp save_params(product_param, params) do
    Inventory.update_product_param!(params, product_param.id)

    EoqWeb.Endpoint.broadcast!("products:lobby", "new_msg", %{
      product_id: product_param.product_id,
      params: params
    })

    Logger.info(
      "Product param #{product_param.id} updated with eoq #{params[:lot_size]}"
    )
  end

  defp eoq(mean, total_time, z, std) do
    round(mean * total_time + z * std * Statistics.Math.sqrt(total_time))
  end

  defp normal_loss_standard(x) do
    Normal.pdf().(x) - x * (1 - Normal.cdf().(x))
  end

  defp cost(cost_holding, avg_demand, review_time_days, z, x_std, cost_ordering, cost_stockout) do
    avg_cost_holding = cost_holding * (avg_demand * review_time_days/2 + x_std * z)
    avg_cost_ordering = cost_ordering / review_time_days
    avg_cost_stockout = cost_stockout * x_std * normal_loss_standard(z) / cost_holding
    round(avg_cost_holding + avg_cost_ordering + avg_cost_stockout)
  end

  def z_factor(confidence_level) do
    Normal.ppf().(confidence_level)
  end
end
