# -*- coding: utf-8 -*-
require 'minitest/unit'
require 'drb/drb'
require 'thread'
require_relative '../resourced'
require_relative '../agent'
require_relative '../process-api'
require_relative './dummy-process'

Minitest::Unit::autorun

SERVER = "localhost" # 使用するIP
PORT = "11212" # 使用するポート番号
URI = "druby://" + SERVER + ":" + PORT 

class TestResourced < MiniTest::Unit::TestCase
  def setup
    # resourced
    Resourced.new(SERVER, PORT).run
=begin
    Thread.start{
      resourced = Resourced.new
      # dRubyのサービスを開始
      DRb.start_service(URI, resourced)
      DRb.thread.join
    }
=end
  end

  def test
    t = Thread.start{
      agent = Agent.new(nil, nil, SERVER, PORT).run
    }

    sleep(0.1)
    Thread.start{
      agent = Agent.new(nil, nil, SERVER, PORT).run
    }
    sleep(0.1)

    Thread.start{
      agent = Agent.new(nil, nil, SERVER, PORT).run
    }
    t.join
  end
end
    
