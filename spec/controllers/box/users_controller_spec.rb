require 'rails_helper'

RSpec.describe UsersController, type: :controller do
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
end
