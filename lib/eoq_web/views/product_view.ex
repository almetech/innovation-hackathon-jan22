defmodule EoqWeb.ProductView do
  use EoqWeb, :view

  def review_time_days(product) do
    [product_param] = product.product_params
    product_param.review_time_days
  end

  def average_demand(product) do
    [product_param] = product.product_params
    product_param.demand_daily || "--"
  end

  def lot_size(product) do
    [product_param] = product.product_params
    product_param.lot_size || "--"
  end
end
