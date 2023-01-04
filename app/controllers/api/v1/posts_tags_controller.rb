class Api::V1::PostsTagsController < ApplicationController
  def index
    @poststags = PostsTag.all
    render json: @poststags
  end

  def create
    @tag = Tag.find_by name: params[:tag_name]
    if @tag
      @posts_tag = PostsTag.new(tag_id: @tag.id, post_id: params[:post_id])
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

  private
  def poststags_params
    params.require(:poststags).permit(:post_id, :tag_name)
  end
end
