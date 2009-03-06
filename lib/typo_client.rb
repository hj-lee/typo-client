# -*- coding: utf-8 -*-

require 'blogger_api'
require 'meta_weblog_api'
require 'movable_type_api'

class TypoClient
  attr_reader :server_url, :user
  def initialize(server_url, user, password)
    @server_url = server_url
    @user = user
    @password = password
  end

  def getRecentPosts(blogid, numberOfPosts, user = nil, password = nil)
    user ||= @user
    password ||= @password
    client = ActionWebService::Client::XmlRpc.new(MetaWeblogApi, @server_url, :handler_name=>'metaWeblog')
    client.getRecentPosts(blogid, user, password, numberOfPosts)
  end
    
end
