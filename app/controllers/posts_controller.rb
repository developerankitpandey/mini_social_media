class PostsController < ApplicationController
  # skip_before_action :verify_authenticity_token
  before_action :authenticate_user!, except: [:index, :show,]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :like, :dislike]

  def index
    @posts = Post.order(created_at: :desc)
    render json: @posts
  end

  def show
    @post = Post.find(params[:id])
     render json: @post 

    # @comment = Comment.new
    # render json: @comment
  end

  # def new
  #   @post = Post.new
  #   render json: @post
  # end

  def create 
    @post = current_user.posts.build(post_params)
    
    if @post.save
      render json: @post, status: :created
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def edit
    # Ensure that only the post owner can edit it
    if current_user != @post.user
      render json: { error: 'You are not authorized to edit this post.' }, status: :forbidden
    end
  end

  def update
    # Ensure that only the post owner can update it
    if current_user == @post.user
      if @post.update(post_params)
        render json: { post: @post, notice: 'Post updated successfully' }, status: :ok
      else
        render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'You are not authorized to update this post' }, status: :forbidden
    end
  end

  def destroy
    @post = Post.find(params[:id])

    # Ensure that only the post owner can delete it
    if current_user == @post.user
      @post.destroy
      render json: { message: 'Post deleted successfully' }, status: :ok
    else
      render json: { error: 'You are not authorized to delete this post' }, status: :forbidden
    end
  end

  def like
    if current_user && !@post.likes.exists?(user: current_user)
      @post.likes.create(user: current_user)
      render json: { message: 'Liked this post' }, status: :ok
    else
      render json: { error: 'You have already liked this post' }, status: :unprocessable_entity
    end
  end

  def dislike
    like = @post.likes.find_by(user: current_user)
    if like
      like.destroy
      render json: { message: 'Disliked this post' }, status: :ok
    else
      render json: { error: 'You have not liked this post to dislike it' }, status: :unprocessable_entity
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Post not found' }, status: :not_found
  end  
 
  def post_params
    params.require(:post).permit(:content, :image)
  end
end
