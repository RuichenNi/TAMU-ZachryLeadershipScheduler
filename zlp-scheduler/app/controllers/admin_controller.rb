class AdminController < ApplicationController
  
  before_action :require_admin, only: [:view_term_admin, :open_semester, :new_term, :update_term, :manage_cohorts, :add_cohort, :manage_administrators, :view_result,:add_student]    
  
  
  def view_term_admin
    @term = Term.find_by active: 1;
    @cohorts = @term.cohorts.order(name: :asc)
  end
  
  def open_semester
    @term = Term.find_by active: 1;
  end
  
  def new_term
    if flash[:selected_term_id]#没用
      @term = Term.find(flash[:selected_term_id])#没用
    else#没用
      @term = Term.find_by active: 1;
    end#没用
    @cohorts = Cohort.all.order(name: :asc)
    @cohort_names = []
    @cohorts.each do |s|
      @cohort_names.push(s.name) 
    end
  end
  
  def update_term
    if params[:term][:name]
      ##updating active term
      # check for selected cohorts before updating anything
      @term = Term.find(params[:term][:name])
      params[:Cohorts] = Cohort.all
      if not params[:Cohorts]
        flash[:notice] = "Please select at least one cohort."#设了notice不显示
        redirect_to new_term_path, flash: {selected_term_id: @term.id} and return
      end
      
      Term.update_all active: false
      @term = Term.find(params[:term][:name])
      if @term.update_attributes(:active => true)#激活一个term之后把数据库里所有的term都赋予这个term
        @cohorts = params[:Cohorts]
        @cohorts.each do |c|
          add_cohort = c    #临时变量是c的引用
          c.chosen_time = nil
          c.flag = 0
          #add_cohort = Cohort.where(:name => c)
          @term.cohorts.push(add_cohort) 
        end
        @scheduletocourse = ScheduleToCourse.all #激活新的term以后要把前一个其他term学生填的课表全都删除
        @scheduletocourse.each do |s|
          s.destroy
        end
        @schedules = Schedule.all
        @schedules.each do |s|
          s.destroy
        end
        open_date = DateTime.yesterday
        close_date = DateTime.new(2099,2,3,4,5,6,'+03:00')
        @term.update_attributes(:opendate => open_date)
        @term.update_attributes(:closedate => close_date)
        LoadCoursesJob.perform_later @term   #LoadCoursesJob的定义在app/jobs里,应该是为term添加对应的subject和课程类
        flash[:notice] = 'Term activated!'
        redirect_to view_term_admin_path
      else
        redirect_to new_term_path
      end
      
    else
      ##updating open and close dates
      @term = Term.find_by active: 1
      open = DateTime.yesterday
      close = DateTime.new(2050,2,3,4,5,6,'+03:00')
      LoadCoursesJob.perform_later @term
      #LoadCoursesJob.set(wait_until: 2.hours.until.open).perform_later(@term)
      if @term.update_attributes(:opendate => open) && @term.update_attributes(:closedate => close)
        flash[:notice] = 'Term open dates updated.'
        redirect_to view_term_admin_path
      else
        flash[:notice] = 'Error - please try again.'
        redirect_to new_term_path
      end
    end
  end
  
  def load_terms
    #grab more term data
    Term.ImportTermList!
    #refresh the page
    flash[:notice] = 'Terms loaded!'
    redirect_to new_term_path
  end
  
  def manage_cohorts 
    @cohorts = Cohort.all.order(name: :asc)
  end
  
  def add_cohort
  end
  
  def view_cohort_semester
    
    @cohort = Cohort.find(params[:id])
    @users = @cohort.users.order(lastname: :asc)

    date_dict = { "M" => "Monday", "T" => "Tuesday", "W" => "Wednesday", "TR" => "Thursday", "F" => "Friday"}
    
    if @cohort.chosen_time.present?
      chosen_timeslot = TimeSlot.find(@cohort.chosen_time)
      chosen_time_start = chosen_timeslot.time
      chosen_time_end = chosen_time_start.advance(:hours => 2)
      @chosen_time = chosen_time_start.strftime("%H:%M") + " - " + chosen_time_end.strftime("%H:%M") + " " + date_dict[chosen_timeslot.day]
      
      if @cohort.flag == 1
        @schedule_change_warning = true
      end
    end
    
  end
  
  def delete_cohort
    @cohort = Cohort.find(params[:id])
    @cohort.destroy
    
    flash[:notice] = 'Cohort deleted!'
    redirect_to manage_cohorts_path
  end
  
  def manage_administrators
    @admins = User.where(:role => 'admin').order(lastname: :asc)
  end
  
  def add_admin
    @user = User.new
  end
  
  def delete_admin
    @admins = User.where(:role => 'admin')
    if @admins.length == 1
      flash[:warning] = "There must be at least 1 administrator at all times."
      redirect_to manage_administrators_path and return
    end
    id = session[:user_id]
    @user = User.find(id)
    @admin = User.find(params[:id])
    if @user == @admin
      @admin.destroy
      flash[:warning] = "You have deleted yourself."
      session[:user_id] = nil
      redirect_to "/"
    else
      @admin.destroy
      flash[:notice] = "Administrator deleted!"
      redirect_to manage_administrators_path
    end
  end
  
  def run_algorithm
    @cohort = Cohort.find(params[:cohort_id])
    @cohort.flag = 0
    @cohort.save()
    Scheduler_2.Generate_time_slots(@cohort)
    flash[:notice] = "The algorithm is finished!"
    redirect_to view_cohort_semester_path(params[:cohort_id])
  end
  
  def change_access
    @cohort = Cohort.find(params[:cohort_id])
    if @cohort.modi.nil? || @cohort.modi?
      @cohort.update_attributes(:modi => false)
      flash[:notice] = "Student Modification Disabled"
    else
      @cohort.update_attributes(:modi => true)
      flash[:notice] = "Student Modification Enabled"
    end
    redirect_to view_cohort_semester_path(params[:cohort_id])
  end
  
  def view_result
    @cohort = Cohort.find(params[:cohort_id])
    @date_dict = { "M" => "Monday", "T" => "Tuesday", "W" => "Wednesday", "TR" => "Thursday", "F" => "Friday"}
    @results = TimeSlot.where(:was_conflict => false, :cohort_id => @cohort.id).order(cost: :asc,id: :asc).limit(200)
    @conflicts = TimeSlot.where(:was_conflict => true, :cohort_id => @cohort.id).order(cost: :asc,id: :asc).limit(200)
  end
  
  def view_conflicts
    @cohort = Cohort.find(params[:cohort_id])
    @final_result = []
    @conflict = TimeSlot.find(params[:conflict_id]).conflicts
    @mandatory_dict = {false => "False", true => "True"}
    @conflict.each do |conf|
      if conf.user_id.present?
          student = User.find(conf.user_id)
          name = student.firstname + ' ' + student.lastname
          conf.reasonid.each do |timeslot_id|
            course = ScheduleToCourse.find_by(id: timeslot_id).reason
            #ScheduleToCourse.find_by(id: timeslot_id)
            time = ScheduleToCourse.find_by(id: timeslot_id).weekday + ": " + ScheduleToCourse.find_by(id: timeslot_id).start_time  + " - " + ScheduleToCourse.find_by(id: timeslot_id).end_time
            #time = course.meetingtime_start.strftime("%H:%M")  + " - " + course.meetingtime_end.strftime("%H:%M") 
            #subject = Subject.find(course.subject_id).subject_code
            #final_subject = subject + ' ' + course.course_number.to_s
            #section_number = course.section_number
            
            schedule_to_course = ScheduleToCourse.find_by(schedule_id: conf.schedule_id)
            #mandatory_value = schedule_to_course.mandatory
            mandatory_value = ScheduleToCourse.find_by(id: timeslot_id).mandatory
            result = [name, course, time, mandatory_value]
            @final_result.append(result)
        end
      end
    end
  end
  
  def select_time
    @cohort = Cohort.find(params[:cohort_id])
    @time_selected = TimeSlot.find(params[:result_id])
    @cohort.chosen_time = @time_selected.id
    
    chosen_day = @time_selected.day
    chosen_time_start = @time_selected.time
    chosen_time_end = chosen_time_start.advance(:hours => 2)
    date_dict = { "M" => "Monday", "T" => "Tuesday", "W" => "Wednesday", "TR" => "Thursday", "F" => "Friday"}
    time_display = chosen_time_start.time.strftime("%H:%M") + " - " + chosen_time_end.strftime("%H:%M") + " " + date_dict[chosen_day]
    
    @cohort.save
    
    flash[:notice] = "The time slot for this cohort had been updated to " + time_display
    redirect_to view_cohort_semester_path(params[:cohort_id])
  end
  
  def student_actions
    @actions = StudentAction.all.order(created_at: :desc)
  end
  
  def add_student
    case request.method_symbol    
      when :get
        @user=User.new()
        session[:cohort_id]=params[:cohort_id]
        @cohort_name=Cohort.find_by(id:params[:cohort_id]).name
        @cohort_id=params[:cohort_id]
    
      when :post
        if User.find_by(email:params[:user][:email]).nil?
          @user = User.new()
          @user.role = 'student'
          @user.firstname=params[:user][:firstname]
          
          @user.lastname=params[:user][:lastname]
          @user.email=params[:user][:email]
          @user.cohort_id = session[:cohort_id]
          @user.uin = params[:user][:uin]
          @user.urgent = params[:user][:urgent]
          @user.password='Temp'
          @user.activate = false
          @user.save!
          flash[:notice] = "A new student has been added."
          redirect_to manage_cohorts_path
        else
          flash[:notice] = "This email address already exists.Please try another email address."
          redirect_to add_student_path(session[:cohort_id]) 
        end
    end
        
  end
  
end
