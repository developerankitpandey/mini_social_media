# app/controllers/posts_controller.rb

class PostsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :set_post, only: [:show, :edit, :update, :destroy, :like, :dislike]
  
    def index
      @posts = Post.all
    end
  
    def show
      @comment = Comment.new
    end
  
    def new
      @post = Post.new
    end
  
    def create
      @post = current_user.posts.build(post_params)
  
      if @post.save
        redirect_to @post, notice: 'Post created successfully.'
      else
        render :new
      end
    end
  
    def edit
      # Ensure that only the post owner can edit it
      if current_user != @post.user
        redirect_to @post, alert: 'You are not authorized to edit this post.'
      end
    end
  
    def update
      # Ensure that only the post owner can update it
      if current_user == @post.user
        if @post.update(post_params)
          redirect_to @post, notice: 'Post updated successfully.'
        else
          render :edit
        end
      else
        redirect_to @post, alert: 'You are not authorized to update this post.'
      end
    end
  
    def destroy
      # Ensure that only the post owner can delete it
      if current_user == @post.user
        @post.destroy
        redirect_to posts_path, notice: 'Post deleted successfully.'
      else
        redirect_to @post, alert: 'You are not authorized to delete this post.'
      end
    end
  
    # def like
    #   @post.likes.create(user: current_user)
    #   redirect_to @post, notice: 'Liked this post.'
    # end
  
    
    def like
        @post = Post.find(params[:id])
        
        if current_user && !@post.likes.exists?(user: current_user)
            @post.likes.create(user: current_user)
            flash[:notice] = 'Liked this post.'
        else
            flash[:alert] = 'You have already liked this post.'
        end
        
        redirect_to @post
    end
    
    def dislike
      like = @post.likes.find_by(user: current_user)
      like.destroy if like
      redirect_to @post, notice: 'Disliked this post.'
    end
    
    private
  
    def set_post
      @post = Post.find(params[:id])
    end
  
    def post_params
      params.require(:post).permit(:content, :image)
    end
  end
  