class Api::V1::PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[ create update destroy]
  before_action :set_post, only: %i[ show update destroy ]

  # GET /posts
  def index
    if params[:tag_id]
      @posts = PostsTag.find_by tag_id: params[:tag_id]
      # @posts = @posts_ids.map { |id| Post.find(id) }
    else
      @posts = Post.all
    end
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
      params.require(:post).permit(:title, :content, :author)
  end
end
