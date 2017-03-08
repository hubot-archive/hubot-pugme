chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'pugme', ->
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

  it 'gets a pug', ->
    @msg =
      http: sinon.stub().returns
        get: sinon.stub().returns sinon.stub().callsArgWith 0, null, null, JSON.stringify
          pug: 'http://25.media.tumblr.com/tumblr_ltc8tzPvTT1qd5kcqo1_500.jpg'
      send: sinon.spy()

    @robot.respond.firstCall.args[1](@msg)

    expect(@msg.http).to.have.been.calledWith 'http://pugme.herokuapp.com/random'
    expect(@msg.send).to.have.been.calledWith 'http://media.tumblr.com/tumblr_ltc8tzPvTT1qd5kcqo1_500.jpg'

  it 'bombs some pugs', ->
    @msg =
      match: []
      http: sinon.stub().returns
        get: sinon.stub().returns sinon.stub().callsArgWith 0, null, null, JSON.stringify
          pugs: [
            'http://25.media.tumblr.com/1.jpg',
            'http://35.media.tumblr.com/2.jpg',
            'http://44.media.tumblr.com/3.jpg',
            'http://55.media.tumblr.com/4.jpg',
            'http://77.media.tumblr.com/5.jpg'
          ]
      send: sinon.spy()

    @robot.respond.secondCall.args[1](@msg)

    expect(@msg.http).to.have.been.calledWith 'http://pugme.herokuapp.com/bomb?count=5'
    expect(@msg.send).to.have.been.calledWith 'http://media.tumblr.com/1.jpg'
    expect(@msg.send).to.have.been.calledWith 'http://media.tumblr.com/2.jpg'
    expect(@msg.send).to.have.been.calledWith 'http://media.tumblr.com/3.jpg'
    expect(@msg.send).to.have.been.calledWith 'http://media.tumblr.com/4.jpg'
    expect(@msg.send).to.have.been.calledWith 'http://media.tumblr.com/5.jpg'

  it 'get pugs count', ->
    @msg =
      match: []
      http: sinon.stub().returns
        get: sinon.stub().returns sinon.stub().callsArgWith 0, null, null, JSON.stringify
          pug_count: 654654
      send: sinon.spy()

    @robot.respond.thirdCall.args[1](@msg)

    expect(@msg.http).to.have.been.calledWith 'http://pugme.herokuapp.com/count'
    expect(@msg.send).to.have.been.calledWith 'There are 654654 pugs.'
