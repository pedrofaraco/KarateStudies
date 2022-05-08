  
Feature: Articles for the homepage

  Background: Define URL
    * url apiUrl
    * def articleRequestBody = read('classpath:conduitApp/json/newArticleRequest.json')
    * def dataGenerator = Java.type('helpers.DataGenerators')
    * def generatedArticleValues = dataGenerator.getRandomArticleValues()
    * set articleRequestBody.article.title = generatedArticleValues.title
    * set articleRequestBody.article.description = generatedArticleValues.description
    * set articleRequestBody.article.body = generatedArticleValues.body

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
    And request articleRequestBody
    When method POST
    Then status 200
    * def articleID = response.article.slug

    Given params {limit: 10, offset: 0}
    Given path 'articles'
    When method GET
    Then status 200
    And match response.articles[0].title == articleRequestBody.article.title

    Given path 'articles',articleID
    When method Delete
    Then status 204
        
    Given params {limit: 10, offset: 0}
    Given path 'articles'
    When method GET
    Then status 200
    And match response.articles[0].title != articleRequestBody.article.title