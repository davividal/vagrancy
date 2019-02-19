require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'user creation' do
    context 'valid data' do
      before do
        user_params = attributes_for(:user)
        post :create, params: { user: user_params }
      end

      it { expect(subject.status).to be_eql(201) }
      it { expect(User.count).to be_eql(1) }
    end
  end

  describe 'fake authentication' do
    context 'packer-post-processor-vagrant-cloud expects HTTP 200 only' do
      it 'should return an empty response with HTTP 200' do
        get :authenticate

        aggregate_failures do
          expect(response.status).to be_eql(200)
          expect(response.body).to be_eql(' ')
        end
      end
    end
  end
end
