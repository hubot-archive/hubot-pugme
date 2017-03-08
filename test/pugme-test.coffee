chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'pugme listens', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()

    require('../src/pugme')(@robot)

  it 'listens for `pug me`', ->
    expect(@robot.respond).to.have.been.calledWith(/pug me/i)

  it 'listens for `pug bomb`', ->
    expect(@robot.respond).to.have.been.calledWith(/pug bomb( (\d+))?/i)

  it 'listens for `how many pugs are there`', ->
    expect(@robot.respond).to.have.been.calledWith(/how many pugs are there/i)
