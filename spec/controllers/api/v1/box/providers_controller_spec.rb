require 'rails_helper'

RSpec.describe Api::V1::Box::ProvidersController, type: :controller do
  describe 'POST box/:username/:name/version/:version/providers' do
    before do
      user = create(:user, username: 'foo')
      box = create(:box, name: 'bar', organization: user.organizations.first)
      create(:version, version: '1.0.0', box: box)
    end

    # Packer info:
    #     POST box/:username/:name/version/:version/providers => 200
    #     type Provider struct {
    #     	Name        string `json:"name"`
    #     	Url         string `json:"url,omitempty"`
    #     	HostedToken string `json:"hosted_token,omitempty"`
    #     	UploadUrl   string `json:"upload_url,omitempty"`
    #     }

    context 'valid virtualbox' do
      let(:expected_json_response) { '{"name":"virtualbox"}' }

      it 'should return the provider' do
        provider_params = attributes_for(:provider)
        post :create,
             params: {
               username: 'foo',
               name: 'bar',
               version: '1.0.0',
               provider: provider_params
             }

        aggregate_failures do
          expect(response.status).to be_eql(200)
          expect(response.body).to be_eql(expected_json_response)
          expect(Provider.count).to be_eql(1)
        end
      end
    end

    context 'valid parallels' do
      let(:expected_json_response) { '{"name":"parallels"}' }

      it 'should return the provider' do
        provider_params = attributes_for(:provider, name: 'parallels')
        post :create,
             params: {
               username: 'foo',
               name: 'bar',
               version: '1.0.0',
               provider: provider_params
             }

        aggregate_failures do
          expect(response.status).to be_eql(200)
          expect(response.body).to be_eql(expected_json_response)
          expect(Provider.count).to be_eql(1)
        end
      end
    end

    context 'provider creation for non-existent version' do
      let(:provider_params) do
        {
          username: 'invalid',
          name: 'invalid',
          version: '1.0.0',
          provider: attributes_for(:provider)
        }
      end

      it 'should return 404 error' do
        post :create, params: provider_params

        expect(response.status).to be_eql(404)
      end
    end
  end

  describe 'GET box/:username/:name/version/:version/provider/:provider/upload' do

    # Packer info:
    #     GET box/:username/:name/version/:version/provider/:provider/upload => 200
    #     type Upload struct {
    #     	UploadPath string `json:"upload_path"`
    #     }

    context 'prepare upload' do
      let(:upload_url) do
        api_v1_box_upload_url(username: 'foo', name: 'bar', version: '1.0.0')
      end
      let(:expected_json_response) do
        "{\"upload_path\":\"#{upload_url}\"}"
      end

      before do
        user = create(:user, username: 'foo')
        box = create(:box, name: 'bar', organization: user.organizations.first)
        version = create(:version, version: '1.0.0', box: box)
        create(:provider, name: 'virtualbox', version: version)
      end

      it 'should return the upload path for the artifact' do
        get :upload_path,
            params: {
              username: 'foo',
              name: 'bar',
              version: '1.0.0',
              provider: 'virtualbox'
            }

        aggregate_failures do
          expect(response.body).to be_eql(expected_json_response)
          expect(response.status).to be_eql(200)
        end
      end
    end

    context 'invalid data' do
      it 'should return 404' do
        get :upload_path,
            params: {
              username: 'invalid',
              name: 'invalid',
              version: '1.0.0',
              provider: 'invalid'
            }

        aggregate_failures do
          expect(response.body).to be_eql(' ')
          expect(response.status).to be_eql(404)
        end
      end
    end
  end

  describe 'PUT UploadPath' do

    # Packer info:
    #     PUT UploadPath, file => 200

    context 'valid image upload' do
      let(:artifact_file) do
        fixture_file_upload(
          Rails.root.join('spec/fixtures/debian-9.5.virtualbox.box'),
          'application/x-gzip'
        )
      end

      before do
        user = create(:user, username: 'foo')
        box = create(:box, name: 'bar', organization: user.organizations.first)
        version = create(:version, version: '1.0.0', box: box)
        create(:provider, name: 'virtualbox', version: version)
      end

      it 'should store the uploaded artifcat' do

        put :upload_path,
            params: {
              username: 'foo',
              name: 'bar',
              version: '1.0.0',
              provider: 'virtualbox',
              artifact: artifact_file
            }

        aggregate_failures do
          expect(response.status).to be_eql(200)
          expect(ActiveStorage::Attachment.count).to be_eql(1)
        end
      end
    end
  end
end
