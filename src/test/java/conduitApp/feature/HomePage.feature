
Feature: Tests for the homepage

Background: Define URL
  Given url apiUrl

  Scenario: Get all tags
    Given path 'tags'
    When method GET
    Then status 200
    And match response.tags contains ['welcome', 'implementations']
    And match response.tags !contains 'truck'
    And match response.tags contains any ['me', 'introduction']
    And match response.tags contains only ['welcome','implementations','codebaseShow','introduction']
    And match response.tags == '#array'
    And match each response.tags == '#string'

  Scenario: Get 10 articles from page
    * def timeValidator = read('classpath:helpers/timeValidator.js')

    Given params {limit: 10, offset: 0}
    Given path 'articles'
    When method GET
    Then status 200
    Then match response.articles == '#[3]'
    Then match response.articlesCount == 3
    Then match response.articlesCount != 4
    And match response == {"articles": '#array', 'articlesCount': 3}
    And match response.articles[0].createdAt contains '2021'
    And match response.articles[*].favoritesCount contains 888
    And match response.articles[*].author.bio contains null
    And match each response..following == '#boolean'
    And match each response..favoritesCount == '#number'
    And match each response..bio == '##string'
    And match each response.articles ==
    """
      {
        "slug": "#string",
        "title": "#string",
        "description": "#string",
        "body": "#string",
        "tagList": "#array",
        "createdAt": "#? timeValidator(_)",
        "updatedAt": "#? timeValidator(_)",
        "favorited": "#boolean",
        "favoritesCount": "#number",
        "author": {
          "username": "#string",
          "bio": null,
          "image": "#string",
          "following": "#boolean"
        }
      }
    """