class PostsController < ApplicationController
  before_action :find_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :require_same_user, only: [:destroy]

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def show
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      flash[:success] = "Photo upload successful"
      redirect_to post_path(@post)
    else
      render 'new'
    end
  end

  def destroy
    @post.destroy
    redirect_to authenticated_root_url
  end

  private 

    def post_params 
      params.require(:post).permit(:image, :description)
    end

    def find_post
      @post = Post.find(params[:id])
    end

    def require_same_user
      if current_user != @post.user
        flash[:danger] = "You can only delete your own photo"
        redirect_to authenticated_root_url
      end
    end
end
