def play_mp3(file_path)
  # open the mp3 in afplay and start playing
  pid = fork{ exec 'afplay', file_path }
  # wait 5 seconds
  # pause
  sleep 5
  Process.kill("SIGSTOP", pid)
  # resume
  sleep 5
  Process.kill("SIGCONT", pid)
  # kill the process using the pid
  sleep 5
  Process.kill("SIGKILL", pid)
end

play_mp3("ES_I Hear The Calling - Wildson.mp3")
