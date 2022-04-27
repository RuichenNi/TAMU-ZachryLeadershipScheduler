class StudentController < ApplicationController
  
   before_action :require_student, only: [:view_terms, :add_schedule, :update_courses, :update_sections, :create_schedule, :view_schedule, :delete_schedule, :edit_schedule]  

  def in_open_term?
    cohort = Cohort.find(@user.cohort_id)
    if !@term.opendate
      return false
    end
    return DateTime.current >= @term.opendate && DateTime.current < @term.closedate && cohort.term_id == @term.id
  end
  
  def view_terms
    id = session[:user_id]
    @user = User.find(id)
    @term = Term.find_by active: 1;
    @cohort = Cohort.find(@user.cohort_id)
    date_dict = { "M" => "Monday", "T" => "Tuesday", "W" => "Wednesday", "TR" => "Thursday", "F" => "Friday"}
    if @cohort.chosen_time.present?
      chosen_timeslot = TimeSlot.find(@cohort.chosen_time)
      chosen_time_start = chosen_timeslot.time
      chosen_time_end = chosen_time_start.advance(:hours => 2)
      @chosen_time = chosen_time_start.strftime("%H:%M") + " - " + chosen_time_end.strftime("%H:%M") + " " + date_dict[chosen_timeslot.day]
    end
    
    if not in_open_term?
      redirect_to closed_path and return
    end
    if @user.schedules
      @schedules = @user.schedules
    else
      @schedules = []
    end
  end
  
  def update_cohort_flag(cohort_id)
    @cohort = Cohort.find(cohort_id)
    if @cohort.chosen_time.present? and @cohort.flag == 0
      @cohort.flag = 1
      @cohort.save
    end
  end

  def add_schedule
    id = session[:user_id]
    @user = User.find(id)
    
    if @user.schedules.length == 3
      flash[:warning] = "You may only add 3 schedules."
      redirect_to view_terms_path
    end
    @schedule = Schedule.new
    
    @term = Term.find_by active: 1;
    @subjects = @term.subjects
    @subjects = @subjects.uniq
    @course_options = [];
    @section_options = [];
    @start_time=[];
    @end_time=[];
    @day_options=["Monday","Tuesday","Wednesday","Thursday","Friday"]
  end

  def update_courses
    @select_id = params[:id]
    @course_options = ['']
    @section_options = ['']

    return unless params[:dept_id]
    subj = Subject.find(params[:dept_id])
    @term = Term.find_by active: 1
    @courses = Course.where(abbreviated_subject: subj.subject_code,
                            term_id: @term.id).order(course_number: :asc)
    @courses.each do |c|
      @course_options.push(c.course_number)
    end
    @course_options = @course_options.uniq

    return unless params[:schedule_id]
    schedule = Schedule.find(params[:schedule_id])
    schedule_courses = schedule.courses.order(abbreviated_subject: :asc, course_number: :asc)
    if schedule
      @select_course = schedule_courses[@select_id.to_i - 1].course_number
      @select_section = schedule_courses[@select_id.to_i - 1].section_number
      @courses.each do |c|
        @section_options.push(c.section_number) if c.course_number == @select_course
      end
      @section_options = @section_options.uniq
    end
  end
  
  def update_sections
    # updates artists and songs based on genre selected
    subj = Subject.find(params[:dept_id])
    @select_id = params[:id]
    if params[:course_num_id].empty?
      @section_options = [].insert(0, "")
    else
      course_num = params[:course_num_id]
      # map to name and id for use in our options_for_select
      @term = Term.find_by active: 1;
      @sections = Course.where(:abbreviated_subject => subj.subject_code, :course_number => course_num, :term_id => @term.id).order(section_number: :asc)
      @section_options = [];
      @sections.each do |c|
        @section_options.push(c.section_number)
      end
      @section_options = @section_options.uniq
      @section_options.insert(0, "")
    end
  end
  
  def create_schedule
    id = session[:user_id]
    is_create = params[:schedule][:id].nil?
    @user = User.find(id)
    if params[:schedule][:name] == ""
      flash[:warning] = 'Schedule must include a name.'
      redirect_to add_schedule_path
    else
      # add courses to schedule, schedule to user
      @term = Term.find_by active: 1;
      if is_create
        @schedule = Schedule.new
      else
        @schedule = Schedule.find(params[:schedule][:id])
        @schedule.courses.clear
      end
      @schedule.update_attributes(:name => params[:schedule][:name])
      # fix the bug in edition
      ScheduleToCourse.where(schedule_id: @schedule.id).destroy_all 
      @user.schedules.push(@schedule)
      warning_word = ""
      
      n=0
      while n < 30
        subj_symb = "dept_id_#{n+1}".to_sym
        number_symb = "course_num_id_#{n+1}".to_sym
        section_symb = "section_num_id_#{n+1}".to_sym
        check_symb = "mand_#{n+1}".to_sym

        startT_symb = "startTime_#{n+1}".to_sym
        endT_symb = "endTime_#{n+1}".to_sym
        rea_symb = "reason_#{n+1}".to_sym
        day_symb = "day_id_#{n+1}".to_sym
        n = n + 1
        params[subj_symb] = "2"
        params[number_symb] = "432"
        params[section_symb] = "900"

        if (params[subj_symb] != "" and params[number_symb] == "") or (params[subj_symb] != "" and params[section_symb] == "")
          warning_word = " Courses without course number or section number will not be added in the schedule!"
        end
        #next if params[subj_symb].empty? or params[number_symb].empty? or params[section_symb].empty?
        #subj = Subject.find(params[subj_symb]).subject_code
        #@course = Course.find_by(abbreviated_subject: subj, course_number: params[number_symb],
        #                        section_number: params[section_symb], term_id: @term.id)
        # prevent duplicate courses in the same schedule
        #next unless @schedule.courses.find_by(id: @course.id).nil?
        if (params[startT_symb] != "" and params[endT_symb] == "") or (params[endT_symb] != "" and params[startT_symb] == "")
          warning_word = " Courses without course number or section number will not be added in the schedule!"
        end

        if (params[startT_symb] !="" and params[endT_symb] !="") 
        #@schedule.courses.push(@course)
        #next if params[check_symb].nil?
        #@schedule_course = ScheduleToCourse.find_by()
          @schedule_course = ScheduleToCourse.new
          @schedule_course.schedule_id=@schedule.id
          @schedule_course.mandatory=params[check_symb]
          @schedule_course.start_time=params[startT_symb]
          @schedule_course.end_time= params[endT_symb]
          @schedule_course.reason=params[rea_symb]
          @schedule_course.weekday=params[day_symb]
          @schedule_course.save
        end
      end
      action = StudentAction.new
      action.user_id = @user.id
      action.schedule_name = @schedule.name
      action.schedule_id = @schedule.id
      action.action = is_create ? 0 : 2
      action.save

      flash[:notice] = (is_create ? 'Schedule added!' : 'Schedule updated!') + warning_word
      user = User.find(session[:user_id])
      update_cohort_flag(user.cohort_id)

      redirect_to view_terms_path
    end
  end
  
  def view_schedule
    @schedule = Schedule.find(params[:id])
    @courses = @schedule.courses.order(abbreviated_subject: :asc, course_number: :asc)
    @cohort = Cohort.find((User.find(session[:user_id])).cohort_id)
    @associations = ScheduleToCourse.where(:schedule_id => @schedule.id)
  end

  def edit_schedule
    id = session[:user_id]
    @user = User.find(id)
    @term = Term.find_by active: 1
    @subjects = @term.subjects.uniq
    @course_options = []
    @section_options = []
    @start_time=[]
    @end_time=[]
    @day_options=["Monday","Tuesday","Wednesday","Thursday","Friday"]
    # information of current schedule to load into form
    @schedule = Schedule.find(params[:id])
    courses = @schedule.courses.order(abbreviated_subject: :asc, course_number: :asc)
    associations = ScheduleToCourse.where(schedule_id: @schedule.id)
    @cur_subject = []
    @cur_mand = []
    @cur_start_time = []
    @cur_end_time = []
    @cur_weekday = []
    @cur_reason= []
    
    # courses.each do |course|
    #   @cur_mand.push((associations.find_by course_id: course.id).mandatory == true)
    #   subj = Subject.find_by(:subject_code => course.subject.subject_code)
    #   @cur_subject.push(subj.nil? ? 0 : subj.id)
    # end
    
    associations.each do |association|
      @cur_mand.push(association.mandatory == true)
      @cur_start_time.push(association.start_time)
      @cur_end_time.push(association.end_time)
      @cur_weekday.push(association.weekday)
      @cur_reason.push(association.reason)
    end
  end
  
  def schedule_params
    params.require(:schedule).permit(:name, course_ids: [])
  end
  
  def delete_schedule
    schedule = Schedule.find(params[:id])
    schedule.destroy
    user = User.find(session[:user_id])
    update_cohort_flag(user.cohort_id)

    action = StudentAction.new()
    action.user_id = session[:user_id]
    action.schedule_name = schedule.name
    action.action = 1
    action.save()
    
    flash[:notice] = 'Schedule deleted!'
    redirect_to view_terms_path
  end
  
  def closed
    id = session[:user_id]
    @user = User.find(id)
  end
end
