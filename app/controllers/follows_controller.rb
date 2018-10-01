class FollowsController < ApplicationController
  def destroy
    @follow = current_user.follows.where(following_id: params[:id]).first
    @follow.destroy
    flash[:notice] = "Successfully unfollowed"
    redirect_to following_path
  end
end