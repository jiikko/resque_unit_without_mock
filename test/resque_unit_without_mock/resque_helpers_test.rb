require "test_helper"

class ResqueHelpersTest < Minitest::TestWithRedis
  def test_resque_run
    assert_equal(0, Resque.info[:processed])
    Resque.enqueue(TestJob, 'test_resque_run')
    assert_equal(1, Resque.info[:pending])
    Resque::Worker.new('*').work_one_job
    assert_equal(0, Resque.info[:pending])
    assert_equal(1, Resque.info[:processed])
  end

  def test_enqueue_job
    lrange_block = ->{ Resque.redis.lrange('queue:normal', 0, -1) }
    assert(lrange_block.call.empty?)
    assert(Resque.queued(:normal).empty?)
    Resque.enqueue(TestJob, 'test_enqueue_job')
    refute(lrange_block.call.empty?)
    refute(Resque.queued(:normal).empty?)
  end
end
