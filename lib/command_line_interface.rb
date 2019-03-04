require "pry"

def welcome_user
  puts "Welcome to BoredQuench: the Gatorade for Boredom. \nYou must be bored."
end

def create_user_with_name
  puts "Please enter username:"
  response = gets.chomp
  puts "Welcome, #{response}!"
  User.create(name: response)
end

def choose_activity
  puts "Please specify the type of activity you'd like to try:
   -Relaxation
   -Cooking
   -Education
   -Social
   -Charity
   -Busywork
   -DIY
   -Music
   -Recreational"
   category = gets.chomp.downcase
   random_activity = RestClient.get("http://www.boredapi.com/api/activity?type=#{category}")
   activity_hash = JSON.parse(random_activity)
   puts activity_hash["activity"].downcase
   Activity.create(name: activity_hash["activity"], accessibility: activity_hash["accessibility"], category: activity_hash["type"], participants: activity_hash["participants"], price: activity_hash["price"])
end
