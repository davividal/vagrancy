class Box::ProvidersController < ApplicationController
  def create
    @provider = Provider.create_from_params(params, provider_params)

    render json: @provider.to_h if @provider.save!
  rescue ActiveRecord::RecordInvalid
    render status: :not_found
  end

  def upload_path
    render get_upload_path if request.method.downcase.to_sym == :get

    render put_upload_path if request.method.downcase.to_sym == :put
  rescue ActiveRecord::RecordNotFound
    render status: :not_found
  end

  private

  def put_upload_path
    provider = Provider.find_from_params(params)
    provider.artifact.attach(params[:artifact])
    { status: :ok }
  end

  def get_upload_path
    Box.tagged(params[:username], params[:name])
    { json: { upload_path: box_upload_url } }
  end

  def provider_params
    params.require(:provider).permit(:name)
  end

  def artifact_params
    params.require(:artifact)
  end
end
