class Api::V1::ProfilesController < ApplicationController
  before_action :authenticate_user!, only: %i[create update destroy]
  before_action :set_profile, only: %i[show update destroy]

  def index
    if params[:user_id]
      @profile = Profile.find_by! user_id: params[:user_id]
      render json: @profile
    elsif params[:username]
      @profile = Profile.find_by! username: params[:username]
      render json: @profile
    else
      @profiles = Profile.all
      render json: @profiles
    end
  end

  def show
    render json: @profile
  end

  def create
    @profile = Profile.new(profile_params)

    if @profile.save
      render json: @profile, status: :created
    else
      render json: @profile.errors, status: :unprocessable_entity
    end
  end

  def update
    if @profile.update(profile_params)
      render json: @profile
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @profile.destroy
  end

  private
  # def get_profile
  #   @profile = current_user.profile
  # end

  def set_profile
    @profile = Profile.find(params[:id])
  end

  def profile_params
    params.require(:profile).permit(:username, :description, :user_id)
  end
end
