API = require 'vue-dmresource'
markdown = require('markdown').markdown
showdown = require('showdown')
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
    markdown_converter: null

  computed:
    preview_url: () ->
      return !@selected_article.previewIsBase64? or @selected_article.previewIsBase64 is false
    header_url: () ->
      return !@selected_article.headerIsBase64? or @selected_article.headerIsBase64 is false
    markdown_html: () ->
      if !@selected_article.body
        return null
      @markdown_converter.makeHtml @selected_article.body

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
        previewImage: ""
        previewIsBase64: false
        headerImage: ""
        headerIsBase64: false
        url: ""
        tags: []

    useLink: (field, event) ->
      console.log field
      if field == "preview"
        @selected_article.previewIsBase64 = false
        @selected_article.previewImage = event.target.value
        #console.log @$refs, @$refs.article_preview_img
        @$refs.article_preview_img.value = ""
      else if field == "header"
        @selected_article.headerIsBase64 = false
        @selected_article.headerImage = event.target.value

    uploadImage: (field, event) ->
      return if !event.target.files? or !event.target.files[0]
      # Get the image, convert to base64, upload to mongodb
      FR= new FileReader()

      FR.addEventListener "load", ((e) =>
        if field == 'preview'
          @selected_article.previewIsBase64 = true
          @selected_article.previewImage = e.target.result
        else if field == 'header'
          @selected_article.headerIsBase64 = true
          @selected_article.headerImage = e.target.result
      )
      FR.readAsDataURL event.target.files[0]

    initSelectUI: () ->
      # Materialize selects need initializing...
      elem = document.querySelector 'select'
      M.FormSelect.init elem, null

  created: ->
    @markdown_converter = new showdown.Converter()
    @get_article_names()

  mounted: ->
    @initSelectUI()
