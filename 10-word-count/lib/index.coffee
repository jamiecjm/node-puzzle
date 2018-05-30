through2 = require 'through2'


module.exports = ->
  words = 0
  lines = 1
  characters = 0
  bytes = 0

  transform = (chunk, encoding, cb) ->
    lines = chunk.split('\n')
    lines = removeEmptyString(lines)

    texts = []

    lines.forEach (line) ->
      # Find quoted phrases
      phrases = line.match(/".*?"/g)
      line = line.replace(/(\s?".*?"\s?)/g, ' ')
      phrases = phrases || []
      texts = texts.concat(phrases)

      # Convert camelcases to normal text
      line = humanize(line)

      remainingWords = line.split(' ')
      texts = texts.concat(remainingWords)

    texts = removeEmptyString(texts)

    # Count number of characters and bytes
    characters = chunk.length
    bytes = lengthInUtf8Bytes(chunk)

    words = texts.length
    lines = lines.length
    return cb()

  flush = (cb) ->
    this.push {words, lines, characters, bytes}
    this.push null
    return cb()

  humanize = (camelcase) ->
     # insert a space before all caps
    return camelcase.replace(/([a-z0-9])([A-Z])/g, '$1 $2')

  removeEmptyString = (array) ->
    return array.filter (e) -> e != ''

  lengthInUtf8Bytes = (str) ->
    # Matches only the 10.. bytes that are non-initial characters in a multi-byte sequence.
    m = encodeURIComponent(str).match(/%[89ABab]/g)
    str.length + (if m then m.length else 0)


  return through2.obj transform, flush
