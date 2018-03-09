API = require 'vue-dmresource'
markdown = require('markdown').markdown
Articles = new API 'articles',
  all_names:
    method: 'GET'
    url: '/names'
  get_article:
    method: 'GET'
    url: '/?'
  save_article:
    method: 'PUT'
    url: '/?'

module.exports =
  name: 'ArticleEditor'

  data: ->
    article_names: []
    selected_article_id: null
    selected_article: null

  computed:
    markdown_html: () ->
      if !@selected_article.body
        return null
      markdown.toHTML @selected_article.body

  methods:
    get_article_names: () ->
      Articles.all_names().then (articles) =>
        @article_names = articles

    get_article: () ->
      if !@selected_article_id or @selected_article_id is '-'
        return
      console.log @selected_article_id
      Articles.get_article("?id="+@selected_article_id).then (article) =>
        console.log article
        @selected_article = article

    save_article: () ->
      Articles.save_article(@selected_article_id, @selected_article).then (article) =>
        console.log article

  created: ->
    @get_article_names()
