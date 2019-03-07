require_relative '../config/environment'

require "ruby-progressbar"

progressbar = ProgressBar.create(title: "Bored?", progress_mark: "~")
100.times { progressbar.increment; sleep 0.01};
CLI.new.run_program
pid = fork{ exec 'killall', "afplay" }
