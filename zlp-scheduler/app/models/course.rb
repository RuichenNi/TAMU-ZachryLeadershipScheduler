require 'nokogiri'
require 'date'
require 'net/http'
require 'json'
require "uri"
# Example of Course in Database
  # full_subject: Accounting
  # abbreviated_subject: ACCT
  # course_name: SURVEY OF ACCT PRIN
  # course_number: 209
  # section_number: 501
  # meetingtime_start: 2020-01-13 08:00:00
  # meetingtime_end: 2020-05-05 09:15:00
  # meeting_days:
  #   - T
  # instructors:
  #   - Morgan E. Clarke
  # meeting_location: Wehner - College of Business 113
  # term: nil
class Course < ApplicationRecord
  belongs_to :term, optional: true
  belongs_to :subject
  has_many :schedule_to_courses
  has_many :schedules, through: :schedule_to_courses
  
  DAY_ABBREV_MAP = {
    'M' => 'monday',
    'T' => 'tuesday',
    'W' => 'wednesday',
    'TR' => 'thursday',
    'F' => 'friday',
    'SA' => 'saturday',
    'SU' => 'sunday'
  }
  
  def self.ImportCourses!(term, subject)
    courses_json = CourseScraper.get_courses(term.term_code, subject.subject_code)
    all_courses = []
    courses_json.each do |course_json|
      c = Course.new
      c.full_subject = course_json['subject_description']
      c.abbreviated_subject = course_json['subject']
      c.course_name = course_json['courseTitle']
      c.course_number = course_json['courseNumber']
      c.section_number = course_json['sequenceNumber']
      #There are potentially many meeting types, Lecture, Exam, Lab, etc...
      #Everyone I've looked at thus far has been lecture first. Unsure how to
      #treat an Exam or Lab period that doesn't happen regularly.
      meetings_faculty = course_json['meetingsFaculty']
      if meetings_faculty.length > 0
        meeting_time = meetings_faculty[0]['meetingTime']
        start_time = meeting_time['beginTime']
        end_time = meeting_time['endTime']
        start_date = meeting_time['startDate']
        end_date = meeting_time['endDate']
        if [start_time, end_time, start_date, end_date].any?{|e| e.nil?}
          c.meetingtime_start = nil
          c.meetingtime_end = nil
        else
          zone = "Central Time (US & Canada)"
          c.meetingtime_start = ActiveSupport::TimeZone[zone].strptime("#{start_date} #{start_time}", "%m/%d/%Y %H%M").utc
          c.meetingtime_end = ActiveSupport::TimeZone[zone].strptime("#{end_date} #{end_time}", "%m/%d/%Y %H%M").utc
        end
        c.meeting_days = []
        DAY_ABBREV_MAP.each do |abbrev, full_day|
          if meeting_time[full_day]
            c.meeting_days << abbrev
          end
        end
      end
      c.instructors = nil
      c.meeting_location = nil
      c.subject_id = subject.id
      c.term_id = term.id
      
      
      all_courses.append(c)
      
    end
    all_courses.each(&:save)
  end
  
  def ==(comparison_object)
    self.attributes == comparison_object.attributes
  end
end


