API = require 'vue-dmresource'
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
    console.log 'created'
    if (@$route.params.id)
      Articles.get_article(@$route.params.id).then (article) =>
        @article = article
    else
      Articles.all().then (articles) =>
        @articles = articles
        console.log @articles.length
