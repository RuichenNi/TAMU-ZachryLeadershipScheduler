class Subject < ApplicationRecord
  belongs_to :term, optional: true
  has_many :courses 
  
  def self.ImportSubjectsForTerm!(term)
    json = CourseScraper.get_subjects(term.term_code)
    all_subjects = []
    json.each do |subject_json|
      s = Subject.new
      s.subject_code = subject_json['code']
      s.subject_description = subject_json['description']
      s.term_id = term.id #term拥有了所有的subject
      all_subjects.append(s)
    end
    all_subjects.each(&:save)
  end
end
