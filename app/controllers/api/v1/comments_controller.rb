class Api::V1::CommentsController < ApplicationController
    before_action :authenticate_user!, only: %i[ create update destory ]
    before_action :set_comment, only: %i[ show update destroy ]
    before_action :set_post, only: %i[ index ]

    def index
        @comments = Comment.where(post_id: @post.id) # filter out the comments under the post

        render json: @comments
    end

    def create
        @comment = Comment.new(comment_params)

        if @comment.save
            render json: @comment, status: :created
            # , location: @commment
        else
            render json: @comment.errors, status: :unprocessable_entity
        end
    end

    def show
        render json: @comment
    end
    
    def update
        if @comment.update(comment_params)
            render json: @comment
        else
            render json: @comment.errors, status: :unprocessable_entity
        end
    end

    def destroy
        @comment.destroy
    end

    private
    def set_post
        @post = Post.find(params[:post_id])
    end
    
    def set_comment
        @comment = Comment.find(params[:id])
    end

    def comment_params
        params.require(:comment).permit(:content, :author, :post_id)
    end
end