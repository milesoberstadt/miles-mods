API = require 'vue-dmresource'
markdown = require('markdown').markdown
Articles = new API 'articles',
  all:
    method: 'GET'
    url: '/'
  get_article:
    method: 'GET'
    url: '/?'

module.exports =
  name: 'KnowledgeBase'

  data: ->
    articles: {}
    article: null

  methods:
    fetch_articles: () ->
      if (@$route.params.id)
        Articles.get_article(@$route.params.id).then (article) =>
          article.body = markdown.toHTML article.body
          @article = article
      else
        Articles.all().then (articles) =>
          @articles = []
          for article in articles
            article.body = markdown.toHTML article.body
            @articles.push article

  created: ->
    @fetch_articles()

  watch:
    '$route': (to, from) ->
      #console.log to, from
      @fetch_articles()
