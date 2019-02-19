require 'rails_helper'

RSpec.describe Api::V1::Box::BoxesController, type: :controller do
  describe 'GET box/:username/:name' do
    # Packer info:
    #     GET box/:username/:name => 200
    #     type Box struct {
    #     	Tag      string     `json:"tag"`
    #     	Versions []*Version `json:"versions"`
    #     }
    #
    #     type Version struct {
    #     	Version     string `json:"version"`
    #     	Description string `json:"description,omitempty"`
    #     }
    #
    #

    context 'basic box, no version' do
      let(:box_json) { '{"tag":"foo/bar","versions":[]}' }

      before do
        user = create(:user, username: 'foo')
        create(:box, name: 'bar', user: user)

        get :show, params: { username: 'foo', name: 'bar' }
      end

      it { expect(subject.status).to be_eql(200) }
      it { expect(subject.response.body).to be_eql(box_json) }
    end

    context 'basic box, one version' do
    end

    context 'basic box, multiple versions' do
    end

    context 'non existent box' do
      before do
        get :show, params: { username: 'invalid', name: 'invalid' }
      end

      it { expect(subject.status).to be_eql(404) }
    end
  end
end
