class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post, only: [:create, :index]
    before_action :set_comment, only: [:show, :update, :destroy]
    
    def index
        @comments = Comment.where(post_id: @post.id)
        render json: {
        comments: @comments,
        status: {code: 200, message: 'Comments retrieved successfully.'}
        }, status: :ok
    end
    
    def show
        render json: {
        comment: @comment,
        status: {code: 200, message: 'Comment retrieved successfully.'}
        }, status: :ok
    end
    
    def create
        @comment = Comment.new(comment_params)
        @comment.user_id = current_user.id
        @comment.post_id = @post.id
    
        if @comment.save
        render json: {
            comment: @comment,
            status: {code: 201, message: 'Comment created successfully.'}
        }, status: :created
        else
        render json: {
            errors: @comment.errors.full_messages,
            status: {code: 422, message: 'Failed to create comment.'}
        }, status: :unprocessable_entity
        end
    end
    
    def update
        if @comment.update(comment_params)
            @comment.update(has_modified: true)
            render json: {
                comment: @comment,
                status: {code: 200, message: 'Comment updated successfully.'}
            }, status: :ok
        else
            render json: {
                errors: @comment.errors.full_messages,
                status: {code: 422, message: 'Failed to update comment.'}
            }, status: :unprocessable_entity
        end
    end
    
    def destroy
        if @comment.destroy
        render json: {
            status: {code: 200, message: 'Comment deleted successfully.'}
        }, status: :ok
        else
        render json: {
            errors: @comment.errors.full_messages,
            status: {code: 422, message: 'Failed to delete comment.'}
        }, status: :unprocessable_entity
        end
    end
    
    private
    
    def set_post
        @post = Post.find(params[:post_id])
    end
    
    def set_comment
        @comment = Comment.find(params[:id])
    end
    
    def comment_params
        params.require(:comment).permit(:content, :has_modified)
    end
end
