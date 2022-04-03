Rails.application.routes.draw do

  #get 'users/index'
  
  get '/' => 'sessions#new'
  get 'signup'  => 'users#new'
  get 'users/reset' => 'users#reset'
  get 'users/new', to: 'users#new', as: "users"
  post 'users/new', to: 'users#create', as: 'create'
  patch 'users/new', to: 'users#update_user', as: 'update_user'
  delete '/users/:id', to: 'users#delete_user', as: 'delete_user'
  
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  
  get 'admin/manage_cohorts', to: 'admin#manage_cohorts', as: 'manage_cohorts'
  get 'users/add_cohort', to: 'users#add_cohort', as: 'add_cohort'
  get 'download_excel_example', to: 'users#download_excel_example'
  post '/cohorts', to: "users#import_from_excel", as: 'create_cohort'
  delete '/cohorts/:id', to: 'admin#delete_cohort', as: 'delete_cohort'
  get 'admin/cohorts/:id', to: 'admin#view_cohort_semester', as: 'view_cohort_semester'
  get '/users/:id', to: 'users#edit_user', as: 'edit_user'
  patch '/users/:id', to: 'users#patch_user', as: 'patch_user'

  
  get 'student/view_terms', to: 'student#view_terms', as: 'view_terms'
  
  get 'student/add_schedule', to: 'student#add_schedule', as: 'add_schedule'
  get 'student/update_courses', :as => 'update_courses'
  get 'student/update_sections', :as => 'update_sections'
  
  get 'student/edit_schedule_path/:id', to: 'student#edit_schedule', as: 'edit_schedule'

  patch 'student/edit_schedule_path/:id', to: 'student#create_schedule', as: 'edit_schedule_done'

  post '/schedules', to: 'student#create_schedule', as: 'schedules'
  delete '/schedules/:id', to: 'student#delete_schedule', as: 'delete_schedule'
  get '/schedules/:id', to: 'student#view_schedule', as: 'view_schedule'
  
  get 'student/closed', to: 'student#closed', as: 'closed'
  
  get 'admin/view_term_admin', to: 'admin#view_term_admin', as: 'view_term_admin'
  
  get 'admin/open_semester', to: 'admin#open_semester', as: 'open_semester'
  
  get 'admin/new_term', to: 'admin#new_term', as: 'new_term'
  get 'admin/load_terms', to: 'admin#load_terms', as: 'load_terms'
  delete '/admins/:id', to: 'admin#delete_admin', as: 'delete_admin'
  
  patch '/terms', to: 'admin#update_term', as: 'term'
  
  get 'admin/manage_administrators', to: 'admin#manage_administrators', as: 'manage_administrators'
  get 'admin/add_admin', to: 'admin#add_admin', as: 'add_admin'
  
  get 'users/signout'

  get 'users/register'

  get 'view_terms/index'
  
  get 'admin/view_result/:cohort_id', to: 'admin#view_result', as: 'view_result'
  get 'admin/view_conflicts/:cohort_id/:conflict_id', to: 'admin#view_conflicts', as: 'view_conflicts'
  
  post 'admin/select_time/:cohort_id/:result_id', to: 'admin#select_time', as:'select_time'
  post 'admin/run_algorithm/:cohort_id', to: 'admin#run_algorithm', as: 'run_algorithm'
  get 'admin/change_access_path/:cohort_id', to: 'admin#change_access', as: 'change_access'
  
  get 'admin/student_actions', to: 'admin#student_actions', as: 'student_actions'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  match 'admin/add_student/:cohort_id', to: 'admin#add_student',as: 'add_student', via: [:get, :post]
end
