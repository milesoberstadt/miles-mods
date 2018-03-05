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
    checkThing: () ->
      console.log 'here', @articles.length

  created: ->
    if (@$route.params.id)
      Articles.get_article(@$route.params.id).then (article) =>
        @article = markdown.toHTML article
    else
      Articles.all().then (articles) =>
        @articles = []
        for article in articles
          article.body = markdown.toHTML article.body
          @articles.push article
