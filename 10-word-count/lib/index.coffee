through2 = require 'through2'


module.exports = ->
  words = 0
  lines = 1

  transform = (chunk, encoding, cb) ->
    lines = chunk.split('\n')
    lines = removeEmptyString(lines)

    words = []

    lines.forEach (line) ->
      # Find quoted phrases
      phrases = line.match(/".*?"/g)
      line = line.replace(/(\s?".*?"\s?)/g, ' ')
      phrases = phrases || []
      words = words.concat(phrases)

      # Convert camelcases to normal text
      line = humanize(line)

      remainingWords = line.split(' ')
      words = words.concat(remainingWords)

    words = removeEmptyString(words)

    words = words.length
    lines = lines.length
    return cb()

  flush = (cb) ->
    this.push {words, lines}
    this.push null
    return cb()

  humanize = (camelcase) ->
     # insert a space before all caps
    return camelcase.replace(/([a-z0-9])([A-Z])/g, '$1 $2')

  removeEmptyString = (array) ->
    return array.filter (e) -> e != ''


  return through2.obj transform, flush
