require 'set'

class Api::V1::PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[ create update destroy]
  before_action :set_post, only: %i[ show update destroy ]

  # GET /posts
  def index
    if params[:profile_id]
      @posts = Post.where(profile_id: params[:profile_id])
    elsif params[:tag_id]
      @posts = PostsTag.find_by tag_id: params[:tag_id]
      # @posts = @posts_ids.map { |id| Post.find(id) }
    elsif params[:tag_name]
      tag = Tag.find_by name: params[:tag_name]
      postsTags = PostsTag.where(tag_id: tag.id)
      @posts = postsTags.map do |postTag|
        Post.find(postTag.post_id)
      end
    elsif params[:tag_names]
      tags = params[:tag_names].map do |tag_name|
        Tag.find_by name: tag_name
      end
      @posts = Set[]
      tags.map do |tag|
        if tag
          postsTags = PostsTag.where(tag_id: tag.id)
          postsTags.map do |postTag|
            post = Post.find(postTag.post_id)
            @posts.add(post)
          end
        end
      end
    elsif params[:username]
      profile = Profile.find_by! username: params[:username]
      @posts = Post.where(profile_id: profile.id)
    else
      @posts = Post.all
    end

    @posts = @posts.order('updated_at DESC')

    render json: @posts
  end

  # GET /posts/1
  def show
    render json: @post
    # @comment = @post.comments.build
  end

  # POST /posts
  def create
    @post = Post.new(post_params)
    @post.profile_id = Profile.find_by!(username: @post.author).id
    if @post.save
      render json: @post, status: :created
      # , location: @post # this causes problems: NoMethodError: (undefined method `post_url'...
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
      params.require(:post).permit(:title, :content, :author, :profile_id, :username, :tag_name, tag_names: [])
  end
end
