# frozen_string_literal: true

module TooThready
  class FiberExample
    def start
      f = Fiber.new do
        puts 'Hi.'
        Fiber.yield
        puts 'Nice Day.'
        Fiber.yield
        puts 'Bye!'
      end
      f.resume
      puts 'Back to the fiber:'
      f.resume
      puts 'One last message from the fiber:'
      f.resume
      puts "That's all!"
    end
  end
end
