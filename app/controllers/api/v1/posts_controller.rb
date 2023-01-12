require 'set'

class Api::V1::PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[ create update destroy]
  before_action :set_post, only: %i[ show update destroy ]

  # GET /posts
  def index
    # get posts by profile_id/tag_name(s)/usernames or all posts, depending on the params
    if params[:profile_id]
      @posts = Post.where(profile_id: params[:profile_id])
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

    # order posts by date updated
    @posts = @posts.sort_by(&:"#{:updated_at}")
    @posts = @posts.reverse

    # pagination
    if params[:page]
      @posts = Kaminari.paginate_array(@posts).page(params[:page]).per(10)
    end

    # get the tags of the posts
    get_tags_from_posts

    render json: { posts: @posts, meta: { totalPosts: Post.count, postsPerPage: 10 }, tags: @tags} 
  end

  # GET /posts/1
  def show
    tags = PostsTag.where(post_id: @post.id).map do |postsTag|
      Tag.find(postsTag.tag_id)
    end

    render json: { post: @post, tags: tags}
  end

  # POST /posts
  def create
    @post = Post.new(post_params)
    @post.profile_id = Profile.find_by!(username: @post.author).id
    if @post.save
      render json: @post, status: :created
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

  def get_tags_from_posts
    @tags = @posts.map do |post|
      PostsTag.where(post_id: post.id).map do |postsTag|
        Tag.find(postsTag.tag_id)
      end
    end
  end

  # Only allow a list of trusted parameters through.
  def post_params
      params.require(:post).permit(:title, :content, :author, :profile_id, :username, :page, :tag_name, tag_names: [])
  end
end
