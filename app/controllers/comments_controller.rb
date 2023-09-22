# app/controllers/comments_controller.rb

class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post
  
    def create
      @comment = @post.comments.build(comment_params)
      @comment.user = current_user
  
      if @comment.save
        redirect_to @post, notice: 'Comment added successfully.'
      else
        redirect_to @post, alert: 'Failed to add comment.'
      end
    end
  
    def destroy
      @comment = @post.comments.find(params[:id])
  
      if current_user == @comment.user
        @comment.destroy
        redirect_to @post, notice: 'Comment deleted successfully.'
      else
        redirect_to @post, alert: 'You are not authorized to delete this comment.'
      end
    end
  
    private
  
    def set_post
      @post = Post.find(params[:post_id])
    end
  
    def comment_params
      params.require(:comment).permit(:content)
    end
  end
  