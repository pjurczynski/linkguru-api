class LinksController < ApplicationController
  before_action :authenticate!

  def index
    links = requested_links(params[:timestamp])
    respond_with links, each_serializer: LinkSerializer
  end

  def create
    link = Link.new(link_params)
    link.user = current_user
    link.save
    if link.valid?
      Notifications::Slack::Link.new(link).call
      Ngnews::Client.publish! "new link #{link.url} added. Details: #{link.description}", 'link'
    end
    respond_with link, serializer: LinkSerializer, location: false
  end

  def update
    link.update(link_params)
    respond_with link, serializer: LinkSerializer
  end

  def destroy
    @link = Link.find(params[:id])
    @link.destroy

    head :no_content
  end

  def upvote
    link.upvote_by(current_user)
    respond_with link, serializer: LinkSerializer, location: false
  end

  def downvote
    link.downvote_by(current_user)
    respond_with link, serializer: LinkSerializer, location: false
  end

  private


  def link
    @link ||= Link.find(params[:link_id] || params[:id])
  end

  def link_params
    params.require(:link).permit(:description, :url, tag_list: [])
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
