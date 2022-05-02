# zlp-scheduler

## Project Description

This project was done on behalf of the Zachary Leadership Program (ZLP) at Texas A&M University College Station. It was started in Spring 2020 with original team members. The ZLP's problem was that they need to find a time slot for a ZLP specific lecture that fits the schedule of all students within a cohort. A cohort is the term for a group of students that started the ZLP at the same time. This is a standard scheduling problem. Given a list of student's schedules, our application should be able to find a time that will work for all students. At least for our first draft, we will have the students enter in three different schedules that they would like to have for their upcoming semester. Then our algorithm will run over the entire cohort's schedules to attempt to find a time slot that is open between all of them. It will then give that time slot to the ZLP admins and inform the students of which schedule they should be using for that time slot to work.

## Project Organization

In accordance with Dr. Walker's expectations, the root directory of the project contains:
```
zlp-scheduler/
../Documentation
../zlp-scheduler
```
The `Documentation` folder contains images, iteration reports, meeting minutes etc. If you were to pickup this project in Fall 2020, you would want to add a subdirectory to Documentation called `Fall2020`. This would be where you can upload releveant reports and documentations during your semester.

The `zlp-scheduler` folder is where the Rails app lives. This folder was created with the standard Rails 5 `rails new zlp-scheduler`. Due to the project organization, the heroku deploy step is slightly different. See that section to deploy to Heroku.

## Deploy to Heroku

The caveat here is the `git subtree` commandwhich will specify to git to push the sub-directory `zlp-scheduler` as the root directory to the heroku remote.

```
# Run from root directory of project
> heroku apps:create
> git remote add heroku #{HEROKU_GIT_REPO}
> git subtree push --prefix zlp-scheduler heroku master
```

After that, you can setup the database
```
> heroku run rake db:migrate 
> heroku run rake db:seed
```
