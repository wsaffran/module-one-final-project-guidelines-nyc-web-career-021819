require "pry"

def welcome_user
  puts "Welcome to BoredQuench: the Gatorade for Boredom. \nYou must be bored."
end

def user_in_database?(username)
  if User.find_by(name: username) != nil
    true
  else
    false
  end
end

def create_or_find_user_and_choose_activity
  puts "Please enter username:"
  response = gets.chomp.downcase
  if user_in_database?(response)
    puts "Welcome back, #{response.capitalize}!"
    puts "What would you like to do today?"
    list_of_categories
    category = gets.chomp.downcase
    a = get_activity_from_api(category)
    user = User.find_by(name: response)
    UserActivity.create(user_id: user.id, activity_id: a.id)
  else
    puts "Welcome, #{response.capitalize}!"
    User.create(name: response)
    list_of_categories
    category = gets.chomp.downcase
    a = get_activity_from_api(category)
    UserActivity.create(user_id: User.find_by(name: response).id, activity_id: a.id)
  end
end

def get_activity_from_api(option)
  random_activity = RestClient.get("http://www.boredapi.com/api/activity?type=#{option}")
  activity_hash = JSON.parse(random_activity)
  puts activity_hash["activity"].downcase
  x = Activity.find_or_create_by(name: activity_hash["activity"], accessibility: activity_hash["accessibility"], category: activity_hash["type"], participants: activity_hash["participants"], price: activity_hash["price"])
  return x
end

def list_of_categories
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
end
