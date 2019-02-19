Rails.application.routes.draw do
  namespace :box do
    scope ':username' do
      scope ':name' do
        get '/', to: 'boxes#show'

        post '/versions', to: 'versions#create'

        scope 'version' do
          post '/:version/providers', to: 'providers#create'

          match '/:version/provider/:provider/upload' => 'providers#upload_path',
                via: [:put, :get],
                as: 'upload'

          put '/:version/release', to: 'versions#release'
        end
      end
    end
  end

  post '/users', to: 'users#create'
end
