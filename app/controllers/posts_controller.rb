class PostsController < ApplicationController
  before_action :find_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def show
    # @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(permit_post)
    if @post.save
      flash[:alert] = "Success!!!"
      redirect_to post_path(@post)
    else
      flash[:alert] = @post.errors.full.messages
      redirect_to new_post_path
    end
  end

  def destroy
    @post.destroy
    redirect_to root_url
  end

  private 

    def permit_post 
      params.require(:post).permit(:image, :description)
    end

    def find_post
      @post = Post.find(params[:id])
    end
end
