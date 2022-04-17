class UsersController < ApplicationController
  before_action :require_admin, only: %i[edit_user delete_user save_records import_from_excel create]

  def new
    @user = User.new
  end

  def reset
    @is_reset = true
    @user = User.new
    render 'new'
  end

  def add_cohort
    @cohort = Cohort.new
  end

  def download_excel_example
    send_file "#{Rails.root}/app/assets/docs/example.xlsx", x_sendfile: true
  end

  def edit_user
    redirect_to '/' unless current_user.admin?
    @user = User.find(params[:id])
  end

  def patch_user
    @user = User.find(params[:id])
    @user.firstname = params[:user][:firstname]
    @user.lastname = params[:user][:lastname]
    @user.uin = params[:user][:uin]
    @user.email = params[:user][:email]
    @user.urgent = params[:user][:urgent]
    if @user.save
      if @user.role == 'student'
        flash[:notice] = "Student updated!"
        redirect_to manage_cohorts_path
      else #admin
        flash[:notice] = "Administrator updated!"
        redirect_to manage_administrators_path
      end
    else
      flash[:warning] = "Error"
      redirect_to edit_user_path(@user)
    end
  end
  
  def delete_user
    @user = User.find(params[:id])
    @user.destroy
    
    flash[:notice] = 'User deleted!'
    redirect_to manage_cohorts_path()
  end
  
  def create_temp_student(row)
    user = User.new
    user.firstname = row[0]
    user.lastname = row[1]
    user.uin = row[2]
    user.email = row[3]
    user.role = 'student'
    user.password = 'Temp'
    user.activate = false
    return user
  end

  def save_records(file)
    file_ext = File.extname(file.original_filename)
    # raise "Unknown file type: #{file.original_filename}" unless [".xls", ".xlsx"].include?(file_ext)
    if [".xls", ".xlsx"].include?(file_ext)
      @cohort = Cohort.new
      @cohort.update_attributes(:name => params[:name])
      spreadsheet = (file_ext == ".xls") ? Roo::Excel.new(file.path) : Roo::Excelx.new(file.path)
      header = spreadsheet.row(1)
      ## We are iterating from row 2 because we have left row one for header
      error_rows = []
      (2..spreadsheet.last_row).each do |i|
        @user = create_temp_student(spreadsheet.row(i))
        error_rows.append(i) unless @user.save
        @cohort.users.push(@user)
      end
      if error_rows.empty?
        flash[:notice] = "Records Imported"
      else
        flash[:warning] = format('Records Imported, but row %s has error', error_rows)
      end
    else
      flash[:warning] = "Import Failed : " + "Unknown file type: #{file.original_filename}"
    end
    # return record_message
  end
  
  def import_from_excel
    begin
      file = params[:file]
      if !file
        flash[:warning] = "Import Failed : File is not chosen"
      elsif params[:name].empty?
        flash[:warning] = "Import Failed : Cohort name is not assigned"
      else
        # Retreive the extension of the file
        save_records(file)
      end
    redirect_to manage_cohorts_path
    end
  end
  
  def create
    @user = User.new
    @user.firstname = params[:user][:firstname]
    @user.lastname = params[:user][:lastname]
    @user.email = params[:user][:email]
    @user.uin = params[:user][:uin]
    @user.role = 'admin'
    @user.password = "Temp"
    @user.activate = false
    flash[:warning] = @user.errors.full_messages unless @user.save
    redirect_to manage_administrators_path
  end

  def handle_reset
    if !@user.activate?
      flash[:login_errors] = ['You should claim your account first']
      redirect_to '/' and return
    elsif @user.schedules.any? and @user.student? and Cohort.find(@user.cohort_id).modi == false
      @user.errors.add(:base, 'Student cannot reset password after Admin disabled modification')
    elsif @user.update_attributes(
      password: params[:user][:password], activate: true,
      password_confirmation: params[:user][:password_confirmation])
      session[:user_id] = @user.id
      if current_user.admin?
        redirect_to view_term_admin_path, notice: 'You have reset your password' and return
      else
        @user.schedules.each do |s|
          s.destroy
          @cohort = Cohort.find(@user.cohort_id)
          @chhort.flag = 1 if @cohort.chosen_time.present? and @cohort.flag == 0
          StudentAction.new(user_id: @user.id, action: 1, schedule_name: s.name, schedule_id: s.id).save
        end
        redirect_to '/student/view_terms', notice: 'You have reset your password' and return
      end
    end
    render 'new'
  end

  def update_user
    @is_reset = params[:commit] == 'Reset Password'
    @term = Term.find_by active: 1
    term.ImportTermList! if @term.nil?
    @user = User.find_by(email: params[:user][:email], uin: params[:user][:uin])
    if @user.nil?
      @user = User.new
      @user.email = params[:user][:email]
      @user.uin = params[:user][:uin]
      @user.errors.add(:email, 'not registered or UIN not matched')
    elsif @is_reset
      return handle_reset
    elsif @user.activate?
      @user.errors.add(:email, 'is already claimed before')
    elsif @user.update_attributes(
      password: params[:user][:password], activate: true,
      password_confirmation: params[:user][:password_confirmation])
      session[:user_id] = @user.id
      if current_user.admin?
        redirect_to view_term_admin_path, notice: 'You have claimed your account' and return
      else
        redirect_to '/student/view_terms', notice: 'You have claimed your account' and return
      end
    end
    render 'new'
  end

  private

  def user_params
    params.require(:user).permit(:role, :uin, :lastname, :firstname, :email, :password, :password_confirmation)
  end
end
