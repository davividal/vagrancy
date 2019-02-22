require 'rails_helper'

RSpec.describe "Api::V1::Box::Providers", type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json" } }
  describe 'packer post' do
    it 'should not return 500 when using timestamp for version' do
      organization = create(:organization, name: 'check24')
      box = create(:box, name: 'debian', organization: organization)
      create(:version, version: '1.0.20190221130911', box: box)

      post '/api/v1/box/check24/debian/version/1.0.20190221130911/providers',
           params: '{"provider":{"name":"virtualbox"}}',
           headers: headers

      aggregate_failures do
        expect(response.status).to be_eql(200)
        expect(response.body).to be_eql('{"name":"virtualbox"}')
        expect(Provider.count).to be_eql(1)
      end
    end

    it 'should not return 500 when using semver' do
      organization = create(:organization, name: 'check24')
      box = create(:box, name: 'debian', organization: organization)
      create(:version, version: '1.0.0', box: box)

      post '/api/v1/box/check24/debian/version/1.0.0/providers',
           params: '{"provider":{"name":"virtualbox"}}',
           headers: headers

      aggregate_failures do
        expect(response.status).to be_eql(200)
        expect(response.body).to be_eql('{"name":"virtualbox"}')
        expect(Provider.count).to be_eql(1)
      end
    end
  end
end
