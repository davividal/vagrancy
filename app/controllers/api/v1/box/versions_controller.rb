module Api
  module V1
    module Box
      class VersionsController < ApplicationController
        def create
          @version = Version.create_from_params(params, version_params)

          render json: @version.to_h if @version.save!
        rescue ActiveRecord::RecordInvalid
          render status: :not_found
        end

        def release
          @version = Version.find_from_params(params)
          @version.release!
          render status: :ok
        end

        private

        def version_params
          params.require(:version).permit(:version, :provider)
        end
      end
    end
  end
end
