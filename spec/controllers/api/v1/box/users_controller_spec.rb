require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'user creation' do
    context 'valid data' do
      it 'should create an user' do
        post :create, params: { user: attributes_for(:user) }

        aggregate_failures do
          expect(response.status).to be_eql(201)
          expect(User.count).to be_eql(1)
        end
      end

      it 'should create an organization with the same username' do
        post :create, params: { user: attributes_for(:user, username: 'foo') }

        aggregate_failures do
          expect(Organization.first.name).to be_eql('foo')
          expect(Organization.count).to be_eql(1)
        end
      end
    end

    context 'username must be unique' do
      before do
        create(:user, username: 'foo')
      end

      it 'should not create the user' do
        post :create, params: { user: attributes_for(:user, username: 'foo') }

        aggregate_failures do
          expect(response.status).to be_eql(422)
          expect(User.count).to be_eql(1)
          expect(Organization.count).to be_eql(1)
        end
      end
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
