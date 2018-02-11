# PAGINATION MIXIN; on first fetch (from component created() or similar), pass a
# callback (component method which actually fetches records) and optional
# beforeRouteLeave (to prevent page switch when changes exist). Example
# component excerpt...
#
# fetch: () ->
#   query.params.offset = @filters.offset if @filters?.offset?
#   query.params.fetch = @filters.fetch if @filters?.fetch?
#   Time.all(query).then (data) =>
#     @vehicles = data.vehicles
#     @totalRecords = data.totalRecords
#   .catch (err) ->
#     console.log err
#
# mixins: [
#   require '../mixins/pages'
# ]
#
# created: ->
#   @fetchBatch @fetch

module.exports =
  data: ->
    batchOffset: 0
    beforeRouteLeave: null
    callback: null
    filters: {}
    pageOffset: 0
    pageQty: 5
    showBatch: 1
    showPage: 1
    showQtyPerPage: 10
    totalRecords: 0

  methods:
    changePage: (velocity) ->
      done = (proceed) =>
        return unless proceed
        if velocity < 0 or (velocity > 0 and @hasNextPage())
          @showPage += velocity
          if @showPage < 1
            if @showBatch > 1
              @showPage = @pageQty
              @showBatch--
              @fetchBatch()
            else
              @showPage = 1
          else if @showPage > @pageQty
            @showPage = 1
            @showBatch++
            @fetchBatch()
          else # new page in same batch
            @fetchBatch()
      return @beforeRouteLeave.call @, {}, {}, done if @beforeRouteLeave? # mock VueRouter navigation guard on page change
      done true

    getPageLabel: (page) -> page + (@showBatch - 1)*@pageQty

    getPageNumbers: ->
      i for i in [1..@pageQty]

    fetchBatch: (callback, beforeRouteLeave) ->
      @callback = callback if callback? # register callback (e.g., component fetch() method)
      @beforeRouteLeave = beforeRouteLeave if beforeRouteLeave? # register navigation guard
      @pageOffset = (@showPage-1)*@showQtyPerPage
      @batchOffset = (@showBatch-1)*@pageQty*@showQtyPerPage
      @filters.offset = @batchOffset + @pageOffset
      @filters.fetch = @showQtyPerPage
      @callback() if @callback? # call component fetch() method

    goToPage: (page) ->
      done = (proceed) =>
        return unless proceed
        if @pageHasRecords(page)
          @showPage = page
          @fetchBatch()
      return @beforeRouteLeave.call @, {}, {}, done if @beforeRouteLeave? # mock VueRouter navigation guard on page change
      done true

    hasNextPage: -> @batchOffset + @showPage*@showQtyPerPage < @totalRecords

    pageHasRecords: (page) -> (page-1)*@showQtyPerPage + @batchOffset < @totalRecords
