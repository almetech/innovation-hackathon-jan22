defmodule EoqWeb.ProductView do
  use EoqWeb, :view

  def review_time_days(product) do
    get_product_param(product, :review_time_days)
  end

  def price(product) do
    get_product_param(product, :price)
  end

  def average_demand(product) do
    get_product_param(product, :demand_daily)
  end

  def cost_holding(product) do
    get_product_param(product, :cost_holding)
  end

  def cost_stockout(product) do
    get_product_param(product, :cost_stockout)
  end

  def lead_time_days(product) do
    get_product_param(product, :lead_time_days)
  end

  def lot_size(product) do
    get_product_param(product, :lot_size)
  end

  def cost(product) do
    get_product_param(product, :cost)
  end

  def service_level(product) do
    get_product_param(product, :service_level)
  end

  def optimum_service_level(product) do
    get_product_param(product, :optimum_service_level)
  end

  def optimum_lot_size(product) do
    get_product_param(product, :optimum_lot_size)
  end

  def optimum_cost(product) do
    get_product_param(product, :optimum_cost)
  end

  def get_product_param(product, param) do
    case product.product_params do
      [product_param] -> Map.get(product_param, param) || "--"
      _ -> "--"
    end
  end
end
