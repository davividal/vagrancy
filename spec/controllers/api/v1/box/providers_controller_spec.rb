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

      before do
        provider_params = attributes_for(:provider)
        post :create,
             params: {
               username: 'foo',
               name: 'bar',
               version: '1.0.0',
               provider: provider_params
             }
      end

      it { expect(subject.status).to be_eql(200) }
      it { expect(subject.response.body).to be_eql(expected_json_response) }
      it { expect(Provider.count).to be_eql(1) }
    end

    context 'valid parallels' do
      let(:expected_json_response) { '{"name":"parallels"}' }

      before do
        provider_params = attributes_for(:provider, name: 'parallels')
        post :create,
             params: {
               username: 'foo',
               name: 'bar',
               version: '1.0.0',
               provider: provider_params
             }
      end

      it { expect(subject.status).to be_eql(200) }
      it { expect(subject.response.body).to be_eql(expected_json_response) }
      it { expect(Provider.count).to be_eql(1) }
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

    before do
      user = create(:user, username: 'foo')
      box = create(:box, name: 'bar', organization: user.organizations.first)
      version = create(:version, version: '1.0.0', box: box)
      create(:provider, name: 'virtualbox', version: version)
    end

    context 'prepare upload' do
      let(:upload_url) do
        api_v1_box_upload_url(username: 'foo', name: 'bar', version: '1.0.0')
      end
      let(:expected_json_response) do
        "{\"upload_path\":\"#{upload_url}\"}"
      end

      before do
        get :upload_path,
            params: {
              username: 'foo',
              name: 'bar',
              version: '1.0.0',
              provider: 'virtualbox'
            }
      end

      it { expect(subject.response.body).to be_eql(expected_json_response) }
      it { expect(subject.status).to be_eql(200) }
    end

    context 'invalid data' do
      before do
        get :upload_path,
            params: {
              username: 'invalid',
              name: 'invalid',
              version: '1.0.0',
              provider: 'invalid'
            }
      end

      it { expect(subject.response.body).to be_eql(' ') }
      it { expect(subject.status).to be_eql(404) }
    end
  end

  describe 'PUT UploadPath' do
    before do
      user = create(:user, username: 'foo')
      box = create(:box, name: 'bar', organization: user.organizations.first)
      version = create(:version, version: '1.0.0', box: box)
      create(:provider, name: 'virtualbox', version: version)
    end

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
        put :upload_path,
            params: {
              username: 'foo',
              name: 'bar',
              version: '1.0.0',
              provider: 'virtualbox',
              artifact: artifact_file
            }
      end

      it { expect(subject.status).to be_eql(200) }
      it { expect(ActiveStorage::Attachment.count).to be_eql(1) }
    end
  end
end
