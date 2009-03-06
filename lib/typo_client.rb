# -*- coding: utf-8 -*-

require 'blogger_api'
require 'meta_weblog_api'
require 'movable_type_api'

class BlogClient
  attr_reader :blog
  def initialize(client, blogStruct)
    @client = client
    @blog = blogStruct
  end

  def getRecentPosts(numberOfPosts = 10, user = nil, password = nil)
    @client.getRecentPosts(@blog.blogid, user, password, numberOfPosts)
  end

  def getRecentPostTitles(numberOfPosts = 10, user = nil, password = nil)
    @client.getRecentPostTitles(@blog.blogid, user, password, numberOfPosts)
  end

  def newPostContent(content, publish = true, user = nil, password = nil)
    @client.newPostContent(@blog.blogid, user, password, content, publish)
  end

  def newPostStruct(struct, publish = 1, user = nil, password = nil)
    @client.newPostStruct(@blog.blogid, user, password, struct, publish)
  end

  #  created - time representing string
  def newPost(title, contents, categories = nil, keywords = nil, created = nil, publish = 1, user = nil, password = nil)
    article = MetaWeblogStructs::Article.new
    article.title = title
    article.description = contents
    article.categories = categories if categories
    article.mt_keywords = keywords if keywords
    article.dateCreated = created if created

    @client.newPostStruct(@blog.blogid, user, password, article, publish)
  end

  # deletePost has meaning?
  def deletePost(postid, publish = 1, user = nil, password = nil)
    user ||= @user
    password ||= @password
    @client.deletePost(postid, user, password, publish)
  end

end

class TypoClient
  attr_reader :server_url, :user
  def initialize(server_url, user, password = nil)
    @server_url = server_url
    @user = user
    @password = password
  end

  ########################################################

  protected 
  
  def get_client(apiClass, handler_name)
    ActionWebService::Client::XmlRpc.new(apiClass, @server_url, :handler_name=>handler_name)
  end

  # MARK - cut and pastes

  def get_blogger_client
    get_client(BloggerApi, 'blogger')
  end

  def get_meta_client
    get_client(MetaWeblogApi, 'metaWeblog')
  end

  def get_movable_client
    get_client(MovableTypeApi, 'mt')
  end
  ########################################################

  public

#   def getUserInfo(user = nil, password = nil)
#     user ||= @user
#     password ||= @password
#     client = get_blogger_client
#     client.getUserInfo('', user, password)
#   end

  def getUsersBlogs(user = nil, password = nil)
    user ||= @user
    password ||= @password
    client = get_blogger_client
    blogs = client.getUsersBlogs('', user, password)
    blogs.map { |blog| BlogClient.new(self, blog) }
  end

  def getRecentPosts(blogid, user, password, numberOfPosts)
    user ||= @user
    password ||= @password
    client = get_meta_client
    client.getRecentPosts(blogid, user, password, numberOfPosts)
  end

  def getRecentPostTitles(blogid, user, password, numberOfPosts)
    user ||= @user
    password ||= @password
    client = get_movable_client
    client.getRecentPostTitles(blogid, user, password, numberOfPosts)
  end

  def newPostContent(blogid, user, password, content, publish)
    user ||= @user
    password ||= @password
    client = get_blogger_client
    client.newPost('', blogid, user, password, content, publish)
  end

  # struct : MetaWeblogStructs::Article
  def newPostStruct(blogid, user, password, struct, publish)
    user ||= @user
    password ||= @password
    client = get_meta_client
    client.newPost(blogid, user, password, struct, publish)
  end

  def deletePost(postid, user, password, publish)
    user ||= @user
    password ||= @password
    client = get_meta_client
    client.deletePost('', postid, user, password, publish)
  end

end
