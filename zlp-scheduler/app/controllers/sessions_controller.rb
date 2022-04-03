class SessionsController < ApplicationController
    def new 
      if logged_in?
        @user = current_user
        create
      end
    end
    
    def create
      if logged_in?
        @user = current_user
      else 
        @user = User.find_by_email(params[:session][:email].downcase)
        if @user.nil? || (@user && !@user.authenticate(params[:session][:password]))
          flash[:login_errors] = ['Email or password is invalid']
          redirect_to '/'
          return
        end
      end
      if @user.activate == false
        flash[:login_errors] = ['You should claim your account first']
        redirect_to '/'
        return
      end
      flash[:notice] = 'Logged in!'
      session[:user_id] = @user.id
      @term = Term.find_by active: 1
      Term.ImportTermList! if @term.nil?
      if current_user.admin?
        redirect_to view_term_admin_path
      else
        redirect_to '/student/view_terms'
      end
    end

    def destroy 
      session[:user_id] = nil
      redirect_to '/login', :notice => "Logged out!" 
    end
end