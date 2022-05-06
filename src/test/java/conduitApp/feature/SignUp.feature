Feature: Test for the user signup

  Background: Define URL
    Given url apiUrl
    # When calling a static method, use:
    * def dataGenerator = Java.type('helpers.DataGenerators')
    * def randomEmail = dataGenerator.getRandomEmail()

    # When calling a non-static method, use:
    * def jsFunction = 
    """
      function () {
        var DataGenerator = Java.type('helpers.DataGenerators')
        var generator = new DataGenerator()
        return generator.getRandomUsername()
      }
    """
    * def randomUsername = call jsFunction

  Scenario: Signup user

    Given path 'users'
    And request
    """
      {
        "user":{
          "email":#(randomEmail),
          "password":"123456",
          "username":#(randomUsername)
        }
      }    
    """ 
    When method POST

    And match response ==
    """
      {
        "user": {
          "email": #(randomEmail),
          "username": #(randomUsername),
          "bio": null,
          "image": "#string",
          "token": "#string"
        }
      }
    """

  @debug
  Scenario Outline: Validate Sign Up error messages

    Given path 'users'
    And request
    """
      {
        "user":{
          "email":"<email>",
          "password":"<password>",
          "username":"<username>"
        }
      }
    """
    When method POST
    Then status 422
    And match response.errors == <errorResponse>

    Examples:
      | email           | password | username              | errorResponse                                                                |
      | #(randomEmail)  | 123456   | Karate123             | {"username": ["has already been taken"]}                                     |
      | karate@test.com | 123456   | #(randomUsername)     | {"email": ["has already been taken"]}                                        |
      | karate@test.com | 123456   | Karate123             | {"email": ["has already been taken"],"username": ["has already been taken"]} |
      |                 | 123456   | #(randomUsername)     | {"email": ["can't be blank"]}                                                |
      | #(randomEmail)  |          | #(randomUsername)     | {"password": ["can't be blank"]}                                             |
      | #(randomEmail)  | 123456   |                       | {"username": ["can't be blank"]}                                             |


