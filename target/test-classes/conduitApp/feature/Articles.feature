Feature: Articles for the homepage

  Background: Define URL
    Given url apiUrl

  #@ignore
  #Scenario: Create a new article
  # Given header Authorization = 'Token ' + token
  #  Given path 'articles'
  #  And request {"article": {"tagList": [], "title": "Three more article", "description": "Three more topic", "body": "Three more text"}}
  #  When method POST
  #  Then status 200
  #  And match response.article.title contains "Three more article"

  Scenario: Create and delete article
    Given path 'articles'
    And request {"article": {"tagList": [],"title": "Article to Delete","description": "Description to Delete","body": "Text do Delete"}}
    When method POST
    Then status 200
    * def articleID = response.article.slug

    Given params {limit: 10, offset: 0}
    Given path 'articles'
    When method GET
    Then status 200
    And match response.articles[0].title == "Article to Delete"

    Given path 'articles',articleID
    When method Delete
    Then status 204
        
    Given params {limit: 10, offset: 0}
    Given path 'articles'
    When method GET
    Then status 200
    And match response.articles[0].title != "Article to Delete"