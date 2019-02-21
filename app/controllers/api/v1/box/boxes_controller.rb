module Api
  module V1
    module Box
      class BoxesController < ApplicationController
        def show
          @box = ::Box.tagged(params[:username], params[:name])

          render json: @box.to_h
        rescue ActiveRecord::RecordNotFound
          render json: nil, status: :not_found
        end
      end
    end
  end
end

