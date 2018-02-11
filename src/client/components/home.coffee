module.exports =
  name: 'Home'

  data: ->
    pageTitle: ""

  methods:
    example_method: ->
      "This transmission is coming to you..."

  created: ->
    @pageTitle = @example_method()
