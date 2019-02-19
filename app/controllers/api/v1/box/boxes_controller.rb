class Api::V1::Box::BoxesController < ApplicationController
  def show
    box = Box.tagged(params[:username], params[:name])

    render json: box.to_h
  rescue ActiveRecord::RecordNotFound
    render json: nil, status: :not_found
  end
end
