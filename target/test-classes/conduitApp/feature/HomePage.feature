Feature: Tests for the homepage

Background: Define URL
  Given url apiUrl

  @ignore
  Scenario: Get all tags
    Given path 'tags'
    When method GET
    Then status 200
    And match response.tags contains ['welcome', 'implementations']
    And match response.tags !contains 'truck'
    And match response.tags == '#array'
    And match each response.tags == '#string'

  @ignore
  Scenario: Get 10 articles from page
    Given params {limit: 10, offset: 0}
    Given path 'articles'
    When method GET
    Then status 200
    Then match response.articles == '#[3]'
    Then match response.articlesCount == 3