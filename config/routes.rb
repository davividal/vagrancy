# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :box do
        scope ':username' do
          scope ':name' do
            get '/', to: 'boxes#show'

            post '/versions', to: 'versions#create'

            scope 'version' do
              post '/:version/providers',
                   to: 'providers#create',
                   constraints: { version: %r{[^\/]+} }

              match '/:version/provider/:provider/upload' => 'providers#upload_path',
                    via: %i[put get],
                    as: 'upload',
                    constraints: { version: %r{[^\/]+} }

              put '/:version/release',
                  to: 'versions#release',
                  constraints: { version: %r{[^\/]+} }
            end
          end
        end
      end

      post '/users', to: 'users#create'

      get '/authenticate', to: 'users#authenticate'
    end
  end
end
