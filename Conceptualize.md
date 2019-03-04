- User
  -name (string)




- Activity
  -name (string)
  -accessibility (float)
  -type (string)
    -["education", "recreational", "social", "diy", "charity", "cooking", "relaxation", "music", "busywork"]
  -participants (integer)
  -price (float)


- User-activity
 -user_id (integer)
 -activity_id (integer)

- Access API
 -RestClient.get("url")
