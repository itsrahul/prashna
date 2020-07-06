class UsersController < ApplicationController
  skip_before_action :authorize

  before_action :set_user, only: [:show, :edit, :update]
  before_action :set_error, only: [:destroy]
  #FIXME_AB: remove index
  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.user.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: t('.success') }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    #FIXME_AB: find_or_initialize_by_name
    @user.topics = Topic.where(name: params[:user][:topic].split(/,\s*/))
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: t('.success') }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    #FIXME_AB: read what does destroy return
    #FIXME_AB: handle a case when user is not destroyed

    respond_to do |format|
      if @user.destroy
        format.html { redirect_to users_url, notice: t('.success') }
        format.json { head :no_content }
      else
        format.html { redirect_to root_path, notice: t('.failure') }
      end
    end
  end

  def verify
    user = User.unverified.find_by_verification_token(params[:token])

    if user && user.activate!
      redirect_to root_path, notice: t('.success')
    else
      redirect_to root_path, notice: t('.failure')
    end
  end

  private  def set_user
      unless (@user = User.find_by(id: params[:id]))
        redirect_to root_path, notice: t('.invalid')
      end
      unless @user == current_user
        redirect_to root_path, notice: t('.invalid')
      end
    end

  private def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  private def set_error
    throw(:abort)
  end

end
