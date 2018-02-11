_date_from_simple_time = (string) ->
  return unless string?
  d = new Date
  parse = string.split ':'
  d.setUTCHours(parse[0], parse[1], 0, 0) if parse.length > 1
  d

_iso_date = (string) ->
  return /T[0-9]{1,2}:[0-9]{1,2}:[0-9]{1,2}/.test string

_pad = (digit) ->
  digit = digit.toString()
  return digit unless digit.length is 1
  return "0#{digit}"

_prettyDate = (string, isoDate=false) ->
  return unless string?
  d = new Date string
  if isoDate
    "#{d.getUTCFullYear()}-#{_pad(d.getUTCMonth()+1)}-#{_pad d.getUTCDate()}"
  else
    "#{d.getUTCMonth()+1}/#{d.getUTCDate()}/#{d.getUTCFullYear()}"

_prettyTime = (string) ->
  return unless string?
  if _iso_date string # ISO datetime
    d = new Date string
  else # simple HH:MM
    d = _date_from_simple_time string
  "#{d.getUTCHours()}:#{_pad d.getUTCMinutes()}"

String::reverse = ->
  arr = []
  for char in @
    arr.unshift char
  arr.join('')

module.exports =
  directives:
    datepicker: # jQueryUI datepicker; use with 'v-datepicker' attribute on INPUT element
      bind: (el, binding, vnode) ->
        vm = vnode.context
        keypath = binding.expression
        el.value = _prettyDate(vm[keypath]) or '' # set <INPUT> initial value
        $(el).datepicker
          onSelect: (date) ->
            vm[keypath] = _prettyDate(date, true)

  filters:
    date: _prettyDate
    time: _prettyTime

  methods:
    clone: (value, drops...) ->
      obj = {}
      for own k,v of value
        obj[k] = v unless k in drops
      obj

    date_from_simple_time: _date_from_simple_time

    currency: (value, dollarSign=true) -> # add DOLLARS thousands separator (,) and ensure two-digit CENTS
      return '0.00' unless value?
      [dollars, cents] = value.toString().split('.')
      if dollars?
        qtyTriplets = Math.ceil(dollars.length / 3) # how many thousands groups?
        if qtyTriplets > 1
          dollars = dollars.reverse() # identify triplets from end of string
          triplets = []
          for i in [1..qtyTriplets] # calculate start and end of each triplet
            triplet_start = (i-1) * 3
            triplet_end = i * 3
            triplets.push dollars.slice(triplet_start, triplet_end)
          dollars = triplets.join(',').reverse() # add commas between each triplet and unreverse string
      else
        dollars = '0'
      if cents?
        cents += '0' if cents.length is 1 # add trailing zero
      else
        cents = '00'
      # Sometimes Money sucks
      if cents.toString().length > 2
        # reduce this to a 2 digit number, then round
        t_cents = Number(cents) / Math.pow(10, (cents.toString().length-2))
        cents = Math.round(t_cents)
      plain = "#{dollars}.#{cents}"
      return if dollarSign then "$#{plain}" else plain # include '$' if requested

    graft: (target, source) ->
      for own k,v of source
        target[k] = v
      target

    iso_date: _iso_date
    pad: _pad
    prettyDate: _prettyDate
    prettyTime: _prettyTime

    sort: (array, key, ascending=true) ->
      return array unless array.length > 0
      invert = if ascending then 1 else -1
      array.sort (a, b) ->
        if a[key] < b[key]
          -1*invert
        else
          if a[key] > b[key]
            1*invert
          else
            0
      array
