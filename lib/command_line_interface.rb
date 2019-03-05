require "pry"

class CLI

  attr_accessor :user, :activity

  def run_program
    welcome_user
    get_username
    find_or_create_user
    puts_list_of_categories
    select_category
    what_next?
    what_next_selections
  end

  def welcome_user
    puts "Welcome to BoredQuench: the Gatorade for Boredom. \nYou must be bored.\n"
  end

  #helper method
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

  def find_or_create_user
    username = gets.chomp
    if user_in_database?(username)
      puts "Welcome back, #{username}"
      self.user= User.find_by(name: username)
    else
      puts "Welcome, #{username}"
      self.user = User.create(name: username)
    end
    # @user = username
  end

  ### Add function to ask user if they would like
  ### to see their activity database

  # helper method
  def get_category
    category = gets.chomp.downcase
    category
  end

  def select_category
    print "\nenter here: "
    create_activity_from_api(get_category)
    puts ""
  end

  def what_next?
    puts "\nwhat number would you like to do?"
    puts "1. complete activity\n2. find a new activity\n3. view completed activities\n4. exit\n"

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
      puts "\nCongratulations #{self.user.name}! You're no longer bored! ... for now... \n"
    end
  end

  # method 1 to what_next_selections
  def add_to_activities
    UserActivity.find_or_create_by(user_id: self.user.id, activity_id: self.activity.id)
  end

  # method 3 to view all activities ***MAKE MORE EFFIECIENT***
  def view_user_activities
    puts "\nYour Activities:\n"
    user_id = User.find_by(name: self.user.name).id
    useractivity = UserActivity.where(user_id: self.user.id)
    # binding.pry
    useractivity.each_with_index do |useractivity, index|
      puts "#{index+1}. #{Activity.find_by(id: useractivity.activity_id).name}"
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
    puts "\nActivity:           #{activity_hash["activity"]}

    accessibility:      #{10 - activity_hash["accessibility"]*10}/10
    participants:       #{activity_hash["participants"]}
    price:              #{activity_hash["price"]*10}/10"

    self.activity = Activity.find_or_create_by(name: activity_hash["activity"], accessibility: activity_hash["accessibility"], category: activity_hash["type"], participants: activity_hash["participants"], price: activity_hash["price"])
    puts ""
  end

end
