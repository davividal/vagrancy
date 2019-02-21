module Api
  module V1
    class UsersController < ApplicationController
      def create
        user = User.new(user_params)

        render status: :created if user.save!
      rescue
        render status: :unprocessable_entity
      end

      def authenticate
        render status: :ok
      end

      private

      def user_params
        params.require(:user).permit(:username, :email, :password)
      end
    end
  end
end
