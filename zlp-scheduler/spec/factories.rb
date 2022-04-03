FactoryBot.define do
    factory :cohort do
    end
    factory :user do
        firstname {Faker::Name.first_name}
        lastname {Faker::Name.last_name}
        email {"%s@tamu.edu" % Faker::Internet.username}
        password {Faker::Internet.password}
    end

    factory :term do
        opendate {Date.current}
        closedate {Date.current.tomorrow}
        active {true}
    end

    factory :course do
      course_number {rand(500)}
      section_number {rand(500)}
    end
    
    factory :schedule do    
    end
    
    factory :subject do     
    end    
end

