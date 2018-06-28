require 'faker'

Event.destroy_all

now = DateTime.now
yesterday = DateTime.now - 1
tomorrow = DateTime.now + 1
next_day = DateTime.now + 2
Event.create!([
    {title: "Run", start_date: yesterday.change({hour: 7, min: 0, sec: 0}), end_date: yesterday.change({hour: 8, min: 0, sec: 0}), description: Faker::Lorem.characters(40)},
    {title: "Wilco Concert", start_date: yesterday.change({hour: 19, min: 0, sec: 0}), end_date: yesterday.change({hour: 21, min: 0, sec: 0}), description: Faker::Lorem.characters(40)},
    {title: "Go to the gym", start_date: now.change({hour: 7, min: 0, sec: 0}), end_date: now.change({hour: 8, min: 30, sec: 0}), description: Faker::Lorem.characters(40)},
    {title: "Listen to Spotify", start_date: now.change({hour: 8, min: 30, sec: 0}), end_date: now.change({hour: 9, min: 0, sec: 0}), description: Faker::Lorem.characters(40)},
    {title: "Build App", start_date: now.change({hour: 9, min: 0, sec: 0}), end_date: now.change({hour: 12, min: 0, sec: 0}), description: Faker::Lorem.characters(40)},
    {title: "Lunch with Jamie", start_date: now.change({hour: 12, min: 30, sec: 0}), end_date: now.change({hour: 13, min: 30, sec: 0}), description: Faker::Lorem.characters(40)},
    {title: "AWS Meetup", start_date: now.change({hour: 18, min: 30, sec: 0}), end_date: now.change({hour: 19, min: 0, sec: 0}), description: Faker::Lorem.characters(40)},
    {title: "3 Day GOT Marathon", start_date: now.change({hour: 20, min: 0, sec: 0}), end_date: next_day.change({hour: 8, min: 30, sec: 0}), description: Faker::Lorem.characters(40)},
    {title: "Run", start_date: tomorrow.change({hour: 7, min: 0, sec: 0}), end_date: tomorrow.change({hour: 8, min: 0, sec: 0}), description: Faker::Lorem.characters(40)},
    {title: "Coffee with Amanda", start_date: tomorrow.change({hour: 8, min: 30, sec: 0}), end_date: tomorrow.change({hour: 9, min: 0, sec: 0}), description: Faker::Lorem.characters(40)},
    {title: "Call Mom", start_date: tomorrow.change({hour: 19, min: 0, sec: 0}), end_date: tomorrow.change({hour: 20, min: 0, sec: 0}), description: Faker::Lorem.characters(40)},
    {title: "Go to the Gym", start_date: next_day.change({hour: 7, min: 0, sec: 0}), end_date: next_day.change({hour: 8, min: 0, sec: 0}), description: Faker::Lorem.characters(40)}
])