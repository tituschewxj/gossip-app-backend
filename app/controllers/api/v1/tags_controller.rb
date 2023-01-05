class Api::V1::TagsController < ApplicationController
  before_action :set_tag, only: %i[show destroy]

  def index
    if params[:post_id]
      @postsTags = PostsTag.where post_id: params[:post_id]
      @tags = @postsTags.map do |postTag|
        Tag.find(postTag.tag_id)
      end
    else
      @tags = Tag.all
    end
    render json: @tags
  end

  def show
    render json: @tag
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      render json: @tag, status: :created
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  def destroy
    # @tag.articles.clear
    @tag.destroy
  end

  private
  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end
