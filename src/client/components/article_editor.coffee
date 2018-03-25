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
        # Update the list of articles in the UI after a delay
        setTimeout(@initSelectUI, 500)

    get_article: () ->
      if !@selected_article_id or @selected_article_id is '-'
        return
      Articles.get_article("?id="+@selected_article_id).then (article) =>
        @selected_article = article

    save_article: () ->
      Articles.save_article(@selected_article_id, @selected_article).then (article) =>
        # Assuming we got an article back, clear fields, reset stuff
        # TODO: Add toastr or equivelent to show that stuff worked
        if (article && article._id?)
          @selected_article_id = null
          @selected_article = null
          @get_article_names()

    new_article: () ->
      @selected_article_id = -1
      @selected_article =
        _id: -1
        title: ""
        body: ""
        url: ""
        tags: []

    initSelectUI: () ->
      # Materialize selects need initializing...
      elem = document.querySelector 'select'
      M.FormSelect.init elem, null

  created: ->
    @get_article_names()

  mounted: ->
    @initSelectUI()
