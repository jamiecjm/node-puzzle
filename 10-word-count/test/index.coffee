assert = require 'assert'
WordCount = require '../lib'
fs = require 'fs'

helper = (input, expected, done) ->
  pass = false
  counter = new WordCount()

  counter.on 'readable', ->
    return unless result = this.read()
    assert.deepEqual result, expected
    assert !pass, 'Are you sure everything works as expected?'
    pass = true

  counter.on 'end', ->
    if pass then return done()
    done new Error 'Looks like transform fn does not work'

  counter.write input
  counter.end()


describe '10-word-count', ->

  it 'should count a single word', (done) ->
    input = 'test'
    expected = words: 1, lines: 1
    helper input, expected, done

  it 'should count words in a phrase', (done) ->
    input = 'this is a basic test'
    expected = words: 5, lines: 1
    helper input, expected, done

  it 'should count quoted characters as a single word', (done) ->
    input = '"this is one word!"'
    expected = words: 1, lines: 1
    helper input, expected, done

describe 'test using fixtures', ->
  it 'should ignore empty lines', (done) ->
    fs.readFile "#{__dirname}/fixtures/1,9,44.txt", 'utf8', (err, data) ->
      if err then return cb err
      input = data.toString()

      expected = words: 9, lines: 1
      helper input, expected, done

  it 'should count quoted characters as a single word', (done) ->
    fs.readFile "#{__dirname}/fixtures/3,7,46.txt", 'utf8', (err, data) ->
      if err then return cb err
      input = data.toString()

      expected = words: 7, lines: 3
      helper input, expected, done

  it 'should count camel cased words as multiple words', (done) ->
    fs.readFile "#{__dirname}/fixtures/5,9,40.txt", 'utf8', (err, data) ->
      if err then return cb err
      input = data.toString()

      expected = words: 9, lines: 5
      helper input, expected, done

  it 'should be able handle a mixture of different cases', (done) ->
    fs.readFile "#{__dirname}/fixtures/mixture.txt", 'utf8', (err, data) ->
      if err then return cb err
      input = data.toString()

      expected = words: 7, lines: 3
      helper input, expected, done
  # !!!!!
  # Make the above tests pass and add more tests!
  # !!!!!
