class LinksController < ApplicationController
  def index
    @links = requested_links(params[:timestamp])

    render json: @links
  end

  def show
    @link = Link.find(params[:id])

    render json: @link
  end

  def create
    @link = Link.new(link_params)

    if @link.save
      render json: @link, status: :created, location: @link
    else
      render json: @link.errors, status: :unprocessable_entity
    end
  end

  def update
    @link = Link.find(params[:id])

    if @link.update(link_params)
      head :no_content
    else
      render json: @link.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @link = Link.find(params[:id])
    @link.destroy

    head :no_content
  end

  private

  def link_params
    params.require(:link).permit(:description, :url)
  end

  def requested_links(timestamp_string)
    if timestamp_string.present? && valid_timestamp?(timestamp_string)
      Link.where('updated_at > ?', timestamp_string)
    else
      Link.all
    end
  end

  def valid_timestamp?(timestamp_string)
    begin
      DateTime.parse(timestamp_string)
    rescue ArgumentError
      return false
    end
    true
  end
end
