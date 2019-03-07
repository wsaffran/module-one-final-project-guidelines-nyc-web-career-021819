require "pry"
require 'artii'

class CLI

  attr_accessor :user, :activity

  def run_program
    welcome_user
    get_username
    find_or_create_user
  end

  def run_2
    puts_list_of_categories
    select_category
    what_next?
    what_next_selections
  end

  def welcome_user
    a = Artii::Base.new
    puts a.asciify('BoredQuench').colorize(:light_green)
    puts "Welcome to BoredQuench: the Gatorade for Boredom. \nYou must be bored.\n\n"
  end

  def user_in_database?(user)
    if User.find_by(name: user) != nil
      true
    else
      false
    end
  end

  def get_username
    print "Please enter username(eg. sharktazer29, aisforawesome123):"
  end

  def if_user_exists_want_to_see_activities?
    puts "Do you want to see your activities? [y/n]"
    response = gets.chomp.downcase

    if response == "y"
      view_user_activities
      ready_to_choose_a_new_activity?
    elsif response == "n"
      ready_to_choose_a_new_activity?
    elsif response != "y" || response != "n"
      puts "I see a typo. Please try again!"
      if_user_exists_want_to_see_activities?
    end
  end

  def ready_to_choose_a_new_activity?
    puts "Ready to choose a new activity? [y,n]"
    response2 = gets.chomp.downcase
    if response2 == "y"
      run_2
    elsif response2 == "n"
      puts "Goodbye, loser!"
      exit!
    elsif response2 != "n" || "y"
      puts "I see a typo. Please try again!"
      ready_to_choose_a_new_activity?
    end
  end

  def find_or_create_user
    username = gets.chomp
    if user_in_database?(username)
      puts "Welcome back, #{username}"
      self.user= User.find_by(name: username)
      if_user_exists_want_to_see_activities?
    else
      puts "Welcome, #{username}"
      self.user = User.create(name: username)
      run_2
    end
  end

  def get_category
    category_array = ["relaxation",
    "cooking",
    "education",
    "social",
    "charity",
    "busywork",
    "diy",
    "music",
    "recreational"]
    category = gets.chomp.downcase
    if category_array.include?(category) == false
      puts "Typo much? Luckily for you, we know how to solve
      your inability to spell!!  Here's an activity picked just for you:"
      create_activity_from_api_when_typo
      print_activity
      what_next?
      what_next_selections
      exit!
    end
    category
  end

  def select_category
    print "\nenter here: "
    create_activity_from_api(get_category)
    print_activity
    puts ""
  end

  def what_next?
    puts "\nWhich number would you like to do?"
    puts "1. Complete and rate activity\n2. Find a new activity\n3. View completed activities\n4. Exit\n"

  end

  def what_next_selections
    answer = gets.chomp
    if answer != "1" && answer != "2" && answer != "3" && answer != "4"
      puts "\nHello?!?!? ARE YOU BLIND??? ENTER A NUMBER 1 - 4"
      what_next?
      what_next_selections
    elsif answer == "1"
      add_to_activities
      puts "\nActivity added to your Activities Database"
      what_next?
      what_next_selections
    elsif answer == "2"
      puts ""
      puts_list_of_categories
      select_category
      what_next?
      what_next_selections
    elsif answer == "3"
      view_user_activities
      puts ""
      what_next?
      what_next_selections

    elsif answer == "4"
      puts "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      puts "\nCongratulations, #{self.user.name}! You're no longer bored! ... for now\n"
    end
  end

  def add_to_activities
    puts "Please enter in a rating between 1.0-5.0"
    rating = gets.chomp
    if 1.0 > rating.to_f || rating.to_f > 5.0
      puts "Not a valid rating.  Next time, read the instructions, ok?"
      add_to_activities
    else
      x = UserActivity.find_by(user_id: self.user.id, activity_id: self.activity.id)
      if x != nil
        x.delete
        UserActivity.create(user_id: self.user.id, activity_id: self.activity.id, rating: rating.to_f)
      else
        UserActivity.find_or_create_by(user_id: self.user.id, activity_id: self.activity.id, rating: rating.to_f)
      end
    end
  end

  def view_user_activities
    puts "\nYour Activities:\n"
    user_id = User.find_by(name: self.user.name).id
    useractivity = UserActivity.where(user_id: self.user.id)
    if useractivity.length == 0
      puts "\nLooks like you don't have any activities yet!"
    else
      useractivity.each_with_index do |useractivity, index|
        activity = "#{index+1}. #{Activity.find_by(id: useractivity.activity_id).name}"
        puts activity + "rating: #{UserActivity.find_by(id: useractivity.id).rating}".rjust(60 - activity.length)
      end
    end
  end

  def puts_list_of_categories
    puts "\nPlease specify the type of activity you'd like to try:
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

  def create_activity_from_api(option)
    random_activity = RestClient.get("http://www.boredapi.com/api/activity?type=#{option}")
    activity_hash = JSON.parse(random_activity)
    self.activity = Activity.find_or_create_by(name: activity_hash["activity"], accessibility: activity_hash["accessibility"], category: activity_hash["type"], participants: activity_hash["participants"], price: activity_hash["price"])
    puts ""
  end

  def create_activity_from_api_when_typo
    random_activity = RestClient.get("http://www.boredapi.com/api/activity")
    activity_hash = JSON.parse(random_activity)
    self.activity = Activity.find_or_create_by(name: activity_hash["activity"], accessibility: activity_hash["accessibility"], category: activity_hash["type"], participants: activity_hash["participants"], price: activity_hash["price"])
    puts ""
  end

  def print_activity
    puts "\nActivity:    #{self.activity.name}\n
    Accessability:       #{self.activity.accessibility}
    Participants:        #{self.activity.participants}
    Price:               #{price_in_dollars}"
  end

  def price_in_dollars
    price = self.activity.price * 10
    price = price.to_i
    if price == 0
      "This activity is free!!!"
    else
      "$" * price
    end
  end
end
