class Api::V1::PostsTagsController < ApplicationController
  before_action :set_posts_tag, only: %i[destroy]

  def index
    if params[:state] === 'destroy' && params[:post_id] && params[:tag_name]
      # deletes the postsTag instead
      @tag = Tag.find_by name: params[:tag_name]
      PostsTag.destroy_by(post_id: params[:post_id], tag_id: @tag.id)
    else 
      @posts_tags = PostsTag.all
      render json: @posts_tags
    end
  end

  def create
    @tag = Tag.find_by name: params[:tag_name]
    if @tag
      # check if unique
      existing_posts_tag = PostsTag.find_by(tag_id: @tag.id, post_id: params[:post_id])
      if existing_posts_tag
        render json: existing_posts_tag, status: :created
      else
        @posts_tag = PostsTag.new(tag_id: @tag.id, post_id: params[:post_id])
      end
    else
      # create new tag
      @tag = Tag.new(name: params[:tag_name])
      if @tag.save
        @posts_tag = PostsTag.new(tag_id: @tag.id, post_id: params[:post_id])
      else
        render json: @tag.errors, status: :unprocessable_entity
      end
    end
    
    if @posts_tag.save
      render json: @post_tag, status: :created
    else
      render json: @posts_tag.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @posts_tag.destroy
  end

  private
  def set_posts_tag
    @posts_tag = PostsTag.find(:id)
  end
  def poststags_params
    params.require(:poststags).permit(:post_id, :tag_name, :id, :state)
  end
end
