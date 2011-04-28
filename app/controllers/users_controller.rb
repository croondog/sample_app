class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end

  def new
    @user = User.new
    @title = "Sign up"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      redirect_to @user, :flash => { :success => "Welcome to the Sample App!" }
    else
      @title = "Sign up"
      #26APR-@user.password = ""
      #26APR-@user.password_confirmation = ""
      render 'new'
    end
  end

  def edit
    #26APR-@user = User.find(params[:id])
    @title = "Edit user"
  end

  def update
    #26APR-@user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to @user, :flash => { :success => "Profile updated" }
    else
      @title = "Edit user"
      render 'edit'
    end
  end


  def destroy
    User.find(params[:id]).destroy
    redirect_to users_path, :flash => { :success => "User destroyed." }
    #26APR-redirect_to users_path
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
  
    def admin_user
      redirect_to(root_path) if current_user && !current_user.admin?
      redirect_to(signin_path) if !current_user
    end

end
