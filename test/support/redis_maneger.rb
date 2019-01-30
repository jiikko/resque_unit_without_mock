class RedisManeger
  root = File.expand_path("../../..", __FILE__)
  REDIS_PID = "#{root}/tmp/pids/redis-test.pid".freeze
  REDIS_CACHE_PATH = "#{root}/tmp/cache/".freeze
  PORT = 9_736

  def self.start
    FileUtils.mkdir_p(['./tmp/pids', './tmp/cache'])
    FileUtils.rm_rf("#{REDIS_CACHE_PATH}/stdout")

    redis_options = {
      'daemonize'     => 'yes',
      'pidfile'       => REDIS_PID,
      'port'          => PORT,
      'timeout'       => 300,
      'save 900'      => 1,
      'save 300'      => 1,
      'save 60'       => 10_000,
      'dbfilename'    => 'dump.rdb',
      'dir'           => REDIS_CACHE_PATH,
      'loglevel'      => 'debug',
      'logfile'       => 'stdout',
      'databases'     => 16
    }.map { |k, v| "#{k} \"#{v}\"" }.join("\n")
    `echo '#{redis_options}' | redis-server -`
  end

  def self.shutdown
    Process.kill(:QUIT, File.read(REDIS_PID).chomp.to_i)
    FileUtils.rm_rf("#{REDIS_CACHE_PATH}dump.rdb")
  end
end