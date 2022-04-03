class LoadCoursesJob < ApplicationJob
  queue_as :default

  def perform(term)
    if term.courses_import_complete == false
      Subject.ImportSubjectsForTerm!(term)#把term学期对应的学科Subject都抓取出来存到Subject表里并且,并且该term会拥有所有的subject
      term.import_all_courses!#把每个subject对应的课都抓给term
    end
  end
end
