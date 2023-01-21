class Api::V1::CommentsController < ApplicationController
    before_action :authenticate_user!, only: %i[ create update destory ]
    before_action :set_comment, only: %i[ show update destroy ]
    # before_action :set_post, only: %i[ index ]

    def index
        if params[:username]
            profile = Profile.find_by! username: params[:username]
            @comments = Comment.where(profile_id: profile.id)
        else
            set_post
            @comments = Comment.where(post_id: @post.id) # filter out the comments under the post
        end

        @comments = @comments.sort_by(&:"#{:updated_at}")
        @comments = @comments.reverse
        
        render json: @comments
    end

    def create
        @comment = Comment.new(comment_params)
        @comment.profile_id = Profile.find_by!(username: @comment.author).id
        if @comment.save
            render json: @comment, status: :created
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
        params.require(:comment).permit(:content, :author, :post_id, :username)
    end
end