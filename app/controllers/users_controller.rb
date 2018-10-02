class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :find_people, :search]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def following
    @follows = current_user.following
  end

  def search
    if params[:search_param].blank?
      flash.now[:danger] = "You have entered an empty search string"
    else
      @users = User.search(params[:search_param])
      if user_signed_in? && current_user
        @users = current_user.except_current_user(@users)
      end
      flash.now[:danger] = "No users match this search criteria" if @users.blank?
    end
    respond_to do |format|
      format.js { render partial: 'users/result' }
    end
  end

  def follow_user
    @following = User.find(params[:following])

    current_user.follows.build(following_id: @following.id)

    if current_user.save
      flash[:success] = "Successfully followed #{@following.username ? @following.username : @following.email}"
    else
      flash[:danger] = "There was something wrong on following the user, please update your username"
    end
    redirect_to user_path(@following)
  end

  def find_people
  end
end