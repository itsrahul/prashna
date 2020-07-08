class UsersController < ApplicationController
  #FIXME_AB: we need to skip authorization for new and create only, edit, update, destroy we need authorization
  skip_before_action :authorize, except: [:index]

  #FIXME_AB: we can remove this before_action. and use current_user directly in actions
  before_action :set_user, only: [:show, :edit, :update]
  #FIXME_AB: remove index
  def index
  end

  def show
  end

  #FIXME_AB: lets make route to /signup
  #FIXME_AB: only non loged in user can access this. before_action
  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.user.new(user_params)

    respond_to do |format|
      #FIXME_AB: after signup I see notice: invalid link
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
    #FIXME_AB: move this method to model's concern and include in user and question model. so that you would be able to use it like: @user.set_topics(params[:user][:topic])
    set_topics(@user, params[:user][:topic])

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
    #FIXME_AB: there is an exception is verification process
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

end
