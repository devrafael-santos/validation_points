class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    authorize @user

    @reviewing_tasks = @user.reviewing_tasks.includes(:epic).order(priority: :desc)
    @active_reviews_count = @reviewing_tasks.count
  end
end
