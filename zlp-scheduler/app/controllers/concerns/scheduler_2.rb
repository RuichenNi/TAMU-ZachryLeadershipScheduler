class Scheduler_2
    @days = ["Monday","Tuesday","Wednesday","Thursday","Friday"]
    
    def self.is_conflict?(day,current_time,schedule)
        @conflictstime = []
        schedule.schedule_to_courses.each do |timeslot|
            if timeslot.start_time!=nil and timeslot.end_time!=nil and timeslot.weekday == day
                if DateTime.strptime(timeslot.end_time, "%H:%M").strftime("%H%M") <= current_time.strftime("%H%M") 
                    next
                elsif DateTime.strptime(timeslot.start_time, "%H:%M").strftime("%H%M") >= current_time.advance(:hours => 2).strftime("%H%M") 
                    next
                else
                    print("\n#####################   ")
                    print(timeslot.id)
                    print("   #####################\n")
                    @conflictstime.append(timeslot.id)
                end
            else
                next
            end
        end
        print("\n$$$$$$$$$$$$$$$$$$$$$$$ ")
        print(@conflictstime)
        print(" $$$$$$$$$$$$$$$$$$$$$$$\n")
        return @conflictstime
    end
    
    def self.exponential_cost_function(current_time, start_of_day, end_of_day)
        
        def self.sigmoid_cost_fuc(max_cost, alpha, beta, x)
            return cost = max_cost / (1+Math::exp(-1*(alpha*max_cost*x) + (beta*max_cost)))
        end
        max_cost = 100
        prior_alpha = -0.015
        prior_beta = 0.025
        later_alpha = 0.015
        later_beta = 0.06
        # https://www.desmos.com/calculator
        
        if current_time < start_of_day
            # cost = max_cost - 1
            x = (current_time.to_f - start_of_day.to_f)/900
            cost = self.sigmoid_cost_fuc(max_cost, prior_alpha, prior_beta, x)
        elsif current_time > end_of_day
            x = (current_time.to_f - end_of_day.to_f)/900
            cost = self.sigmoid_cost_fuc(max_cost, later_alpha, later_beta, x)
        else
            cost = 0
        end
        return cost
    end
    
    
    def self.Generate_time_slots(cohort)
        
        TimeSlot.where(:cohort_id => cohort.id).destroy_all
        cohort.chosen_time = nil
        conflict_mods = Array.new
        time_preferences = Array.new
        time_slots = Array.new
        
        #start_time_timing = Time.now
        @days.each do |day|
            #soft time preference
            prior_of_day = Time.new(2020,12,9,8,0,0)
            later_of_day = Time.new(2020,12,9,20,0,0)
            current_time = prior_of_day
            
            #hard time preference
            start_of_day =  Time.new(2020,12,9,8,0,0)
            end_of_day =    Time.new(2020,12,9,15,0,0)
            
            
            while current_time < later_of_day
                @time_slot = TimeSlot.new
                @time_slot.time = current_time
                @total_cost = 0
                @conflict = []
                @true_conflict = false
                
                cohort.users.each do |student|
                    
                    student.schedules.each_with_index do |schedule, index|
                        @conflict = self.is_conflict?(day,current_time,schedule)
                        print("*****************************\n")
                        print(student.lastname)
                        print("\n",index,"\n")
                        print(@conflict)
                        print("*****************************\n")
                        if(@conflict.length == 0) 
                            next
                        end
                        #print(@conflict)
                        #start_time = Time.now
                        @conflict_mod = Conflict.new
                        @conflict_mod.user = student
                        @conflict_mod.cost =2**(2*index) - 1
                        @conflict.each do |timeslotid|
                            @conflict_mod.cost = ScheduleToCourse.find_by(:id => timeslotid).mandatory ? @conflict_mod.cost + 4 : @conflict_mod.cost + 1 #  schedule.schedule_to_courses.find_by(course_id: @conflict.id)
                        end
                        @conflict_mod.cost = student.urgent ? @conflict_mod.cost + 1000 : @conflict_mod.cost
                        @conflict_mod.reasonid = @conflict
                        @conflict_mod.schedule = schedule
                        conflict_mods.append(@conflict_mod)
                        #@conflict_mod.save
                        @total_cost += @conflict_mod.cost
                        @time_slot.conflicts.push(@conflict_mod)
                        #end_time = Time.now
                        #puts "Time Elasped for conflict #{(end_time-start_time)*1000} milliseconds"

                    end
                    if @conflict.length > 0
                        @true_conflict = true
                    end
                    
                end
                
                
                #start_time = Time.now
                @time_preference_cost = self.exponential_cost_function(current_time, start_of_day, end_of_day)
                # @time_preference_mod = Conflict.new
                # @time_preference_mod.cost = @time_preference_cost
                # #start_time_save = Time.now
                # time_preferences.append(@time_preference_mod)
                # #end_time_save = Time.now
                # #end_time = Time.now
                # #puts "Time Elasped for time_preference #{(end_time-start_time)*1000} milliseconds saving took #{(end_time_save-start_time_save) *1000}"
                # #print(current_time)
                # #print("Time cost ", @time_preference_mod.cost,"\n")
                # @time_slot.conflicts.push(@time_preference_mod)
                
                @time_slot.cost = @total_cost + @time_preference_cost #@time_preference_mod.cost
                
                if not @true_conflict
                    @time_slot.was_conflict = false
                else
                    #print("Set Conflict")
                    @time_slot.was_conflict = true
                end
                @time_slot.day = day
                time_slots.append(@time_slot)
                cohort.time_slots.push(@time_slot)
                current_time += 60*15
                
            end
            
        end
        conflict_mods.each(&:save!)
        time_preferences.each(&:save!)
        time_slots.each(&:save!)
        cohort.save
        #end_time_timing = Time.now
        #puts "Time Elasped to run algorithm #{(end_time_timing-start_time_timing)*1000} milliseconds"
    end
    
end