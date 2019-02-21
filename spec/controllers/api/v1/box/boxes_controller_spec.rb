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

    context 'box belongs to organization, not user' do
      let(:box_json) { '{"tag":"foo/bar","versions":[]}' }

      it 'should return box from organization' do
        organization = create(:organization, name: 'foo')
        create(:box, name: 'bar', organization: organization)

        get :show, params: { username: 'foo', name: 'bar' }

        aggregate_failures do
          expect(response.status).to be_eql(200)
          expect(response.body).to be_eql(box_json)
        end
      end

      it 'should return box from user as organization' do
        user = create(:user, username: 'foo')
        create(:box, name: 'bar', organization: user.organizations.first)

        get :show, params: { username: 'foo', name: 'bar' }

        aggregate_failures do
          expect(response.status).to be_eql(200)
          expect(response.body).to be_eql(box_json)
        end
      end
    end

    context 'one version' do
      let(:box_json) do
        '{"tag":"foo/bar","versions":[{"version":"1.0.0"}]}'
      end

      before do
        user = create(:user, username: 'foo')
        box = create(:box, name: 'bar', organization: user.organizations.first)
        create(:version, version: '1.0.0', box: box)
      end

      it 'should return box with version' do
        get :show, params: { username: 'foo', name: 'bar' }

        aggregate_failures do
          expect(response.status).to be_eql(200)
          expect(response.body).to be_eql(box_json)
        end
      end
    end

    context 'multiple versions' do
      let(:box_json) do
        '{"tag":"foo/bar","versions":[{"version":"1.0.0"},{"version":"2.0.0"}]}'
      end

      before do
        user = create(:user, username: 'foo')
        box = create(:box, name: 'bar', organization: user.organizations.first)
        create(:version, version: '1.0.0', box: box)
        create(:version, version: '2.0.0', box: box)
      end

      it 'should return box with versions' do
        get :show, params: { username: 'foo', name: 'bar' }

        aggregate_failures do
          expect(response.status).to be_eql(200)
          expect(response.body).to be_eql(box_json)
        end
      end
    end

    context 'non existent box' do
      it 'should return 404' do
        get :show, params: { username: 'invalid', name: 'invalid' }

        expect(response.status).to be_eql(404)
      end
    end
  end
end
