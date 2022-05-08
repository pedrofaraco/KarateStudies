
Feature: Home Work

    Background: Preconditions
        * url apiUrl
        * def articleRequestBody = read('classpath:conduitApp/json/newArticleRequest.json')
        * def dataGenerator = Java.type('helpers.DataGenerators')
        * def generatedArticleValues = dataGenerator.getRandomArticleValues()
        * set articleRequestBody.article.title = generatedArticleValues.title
        * set articleRequestBody.article.description = generatedArticleValues.description
        * set articleRequestBody.article.body = generatedArticleValues.body
        * def timeValidator = read('classpath:helpers/timeValidator.js')
        * def favoriteRequestResponse = read('classpath:conduitApp/json/favoriteRequest.json')
        * def favoritedArticlesRequest = read('classpath:conduitApp/json/favoritedArticlesRequest.json')
        * def commentsRequest = read('classpath:conduitApp/json/commentsRequest.json')
        * def randomComment = dataGenerator.getRandomComment()

    Scenario: Favorite articles
        # Step 0: Create new article
        Given path 'articles'
        And request articleRequestBody
        When method POST
        Then status 200
        # Step 1: Get atricles of the global feed
        Given params {'limits': 10, 'offset': 0}
        Given path 'articles'
        When method GET
        Then status 200
        # Step 2: Get the favorites count and slug ID for the first arice, save it to variables
        * def favoritesCount = response.articles[0].favoritesCount
        * def slugID = response.articles[0].slug
        # Step 3: Make POST request to increse favorites count for the first article
        Given path 'articles', slugID, 'favorite'
        When method POST
        Then status 200
        # Step 4: Verify response schema
        And match response.article == favoriteRequestResponse
        # Step 5: Verify that favorites article incremented by 1
        And match response.article.favoritesCount == favoritesCount + 1
        # Step 6: Get all favorite articles
        Given params {'favorited': 'MyKarate', 'limit':10, 'offset':0}
        Given path 'articles'
        When method GET
        Then status 200
        # Step 7: Verify response schema
        And match response == {'articles': '#array', 'articlesCount': '#number'}
        And match each response.articles == favoritedArticlesRequest
        # Step 8: Verify that slug ID from Step 2 exist in one of the favorite articles
        And match response..slug contains slugID

    @debug
    Scenario: Comment articles
        # Step 1: Get atricles of the global feed
        Given params {'limits': 10, 'offset': 0}
        Given path 'articles'
        When method GET
        Then status 200
        # Step 2: Get the slug ID for the first arice, save it to variable
        * def slugID = response.articles[0].slug
        # Step 3: Make a GET call to 'comments' end-point to get all comments
        Given path 'articles', slugID, 'comments'
        When method GET
        Then status 200
        # Step 4: Verify response schema
        And match response == {'comments': '#array'}
        And match each response.comments == commentsRequest
        # Step 5: Get the count of the comments array lentgh and save to variable
        * def commentsCount = response.comments.length
        * print commentsCount
        # # Step 6: Make a POST request to publish a new comment
        Given path 'articles', slugID, 'comments'
        And request {'comment': {'body': #(randomComment)}}
        When method POST
        Then status 200
        # # Step 7: Verify response schema that should contain posted comment text
        And match response.comment == commentsRequest
        And match response.comment.body == randomComment
        # Step 8: Get the list of all comments for this article one more time
        Given path 'articles', slugID, 'comments'
        When method GET
        Then status 200
        # Step 9: Verify number of comments increased by 1 (similar like we did with favorite counts)
        * def commentsCountNew = response.comments.length
        And match commentsCountNew == commentsCount + 1
        * def commentToDelete = response.comments[0].id
        # # Step 10: Make a DELETE request to delete comment
        Given path 'articles', slugID, 'comments', commentToDelete
        When method DELETE
        Then status 204
        # # Step 11: Get all comments again and verify number of comments decreased by 1
        Given path 'articles', slugID, 'comments'
        When method GET
        Then status 200
        * def commentsCountNewer = response.comments.length
        And match commentsCountNewer == commentsCountNew - 1