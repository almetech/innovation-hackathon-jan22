defmodule EoqWeb.ProductView do
  use EoqWeb, :view

  def review_time_days(product) do
    get_product_param(product, :review_time_days)
  end

  def average_demand(product) do
    get_product_param(product, :demand_daily)
  end

  def lot_size(product) do
    get_product_param(product, :lot_size)
  end

  def get_product_param(product, param) do
    case product.product_params do
      [product_param] -> Map.get(product_param, param) || "--"
      _ -> "--"
    end
  end
end
