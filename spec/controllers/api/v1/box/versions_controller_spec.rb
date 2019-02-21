require 'rails_helper'

RSpec.describe Api::V1::Box::VersionsController, type: :controller do
  describe 'POST box/:username/:name/versions' do

    # Packer info:
    #     POST box/:username/:name/versions => 200
    #     type Version struct {
    #     	Version     string `json:"version"`
    #     	Description string `json:"description,omitempty"`
    #     }
    #

    context 'version creation' do
      let(:expected_json_response) { '{"version":"1.0.0"}' }

      it 'should return the created version' do
        user = create(:user, username: 'foo')
        create(:box, name: 'bar', organization: user.organizations.first)
        version_params = attributes_for(:version, version: '1.0.0')

        post :create,
             params: { username: 'foo', name: 'bar', version: version_params }

        aggregate_failures do
          expect(response.body).to be_eql(expected_json_response)
          expect(response.status).to be_eql(200)
          expect(Version.count).to be_eql(1)
        end
      end
    end

    context 'version creation for non-existent box' do
      let(:version_params) do
        {
          username: 'invalid',
          name: 'invalid',
          version: attributes_for(:version)
        }
      end

      it 'should return 404 error' do
        post :create, params: version_params

        expect(response.status).to be_eql(404)
      end
    end
  end

  describe 'PUT box/:username/:name/version/:version/release' do

    # Packer info:
    #     PUT box/:username/:name/version/:version/release => 200

    it 'should release a version' do
      user = create(:user, username: 'foo')
      box = create(:box, name: 'bar', organization: user.organizations.first)

      version = create(:version, version: '1.0.0', box: box)
      create(:provider, name: 'virtualbox', version: version)

      put :release, params: { username: 'foo', name: 'bar', version: '1.0.0' }

      aggregate_failures do
        expect(response.status).to be_eql(200)
        expect(Version.find(version.id).released).to be_eql(true)
      end
    end
  end
end
