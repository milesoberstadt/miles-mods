API = require 'vue-dmresource'
# TODO Finish replacing markdown with showdown
markdown = require('markdown').markdown
showdown = require('showdown')
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
    markdown_converter: null

  methods:
    fetch_articles: () ->
      if (@$route.params.url)
        Articles.get_article("?url="+@$route.params.url).then (article) =>
          article.body = @markdown_converter.makeHtml article.body
          @article = article
      else
        Articles.all().then (articles) =>
          @articles = []
          for article in articles
            article.preview = @get_article_preview article.body
            @articles.push article

    get_article_preview: (bodyMarkup) ->
      bodyTree = markdown.parse bodyMarkup
      preview = ""
      # Find the first paragraph and clip it
      for item in bodyTree
        if item[0] is 'para'
          preview = @markdown_converter.makeHtml item[1]
          break
      preview

  created: ->
    @markdown_converter = new showdown.Converter()
    @fetch_articles()

  watch:
    '$route': (to, from) ->
      #console.log to, from
      @fetch_articles()
