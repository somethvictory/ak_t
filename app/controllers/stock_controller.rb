class StockController < ApplicationController
  def index
    stock_service = StockService.new(params).call

    render json: stock_service

  rescue StockService::Error => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end