# frozen_string_literal: true

module TooThready
  class ThreadExample
    def start(options)
      example = "example#{options.fetch(:example, 1)}"
      raise "Invalid code example: #{example}" unless self.class.private_method_defined?(example)
      send(example)
    end

    private

    def example1
      puts 'Outside: 1'
      Thread.new do
        puts 'Inside: 1'
        sleep 1
        puts 'Inside: 2'
      end
      puts 'Outside: 2'
    end

    def example2
      puts 'Outside: 1'
      t = Thread.new do
        puts 'Inside: 1'
        sleep 1
        puts 'Inside: 2'
      end
      puts 'Outside: 2'
      t.join
    end

    def example3
      puts 'Trying to read in some files...'
      t = Thread.new do
        (0..2).each do |i|
          begin
            File.open(File.expand_path(File.join(__dir__, '..', '..', 'fixtures', "part0#{i}.txt"))) do |f|
              f.readlines.each do |line|
                puts line
              end
            end
          rescue Errno::ENOENT
            puts "Message from thread: Failed on i=#{i}"
            exit
          end
        end
      end
      t.join
      puts 'Finished!'
    end

    def example4
      t = Thread.new do
        puts '[Starting thread]'
        Thread.stop
        puts '[Resuming thread]'
      end
      puts "Status of thread: #{t.status}"
      puts "Is the thread stopped?: #{t.stop?}"
      puts "Is the thread alive?: #{t.alive?}"
      puts
      puts 'Waking up thread and joining it...'
      t.wakeup
      t.join
    end

    def example5
      t = Thread.new do
        Thread.current[:message] = 'Hello, World!'
      end
      t.join
      p t.keys
      puts t[:message]
    end
  end
end