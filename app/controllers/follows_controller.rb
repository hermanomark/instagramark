class FollowsController < ApplicationController
  def destroy
    @following = User.find(params[:id])
    @follow = current_user.follows.where(following_id: @following.id).first
    @follow.destroy
    flash[:success] = "Successfully unfollowed #{@following.username}"
    redirect_to user_path(params[:id])
  end
end