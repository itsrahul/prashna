class UsersController < ApplicationController
  skip_before_action :authorize

  before_action :set_user, only: [:show, :edit, :update]

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
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: t('.success') }
      format.json { head :no_content }
    end
  end

  def verify
    user = User.unverified.find(params[:token])

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
    end

  private def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
