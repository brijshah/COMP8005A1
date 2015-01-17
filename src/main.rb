#!/usr/bin/ruby

require 'benchmark'
require 'logger'
require 'thread'

@DEFAULT_WORKERS = 5

@log = Logger.new('log.txt') 
@log2 = Logger.new('ruby_performance.txt')

def prime_factors(i)
    v = (2..i-1).detect{|j| i % j == 0}
    v ? ([v] + prime_factors(i/v)) : [i]
end


def startProcesses
	@log.info 'starting process performance test'

	processes = (1..@DEFAULT_WORKERS).map do |p|
		Process.fork do
			@log.info "pid:#{Process.pid} began"
            	for j in 0..1000
                	@log.info "pid:#{Process.pid} #{j}: #{prime_factors(j)}"
            	end
			@log.info "pid:#{Process.pid} completed"
		end
	end
	processes.each {|p| Process.wait p}
	@log.info 'process performance test completed'
end

def startThreads
	@log.info 'starting thread performance test'

	threads = (1..@DEFAULT_WORKERS).map do |t|
		Thread.new(t) do |t|
			@log.info "#{Thread.current} began"
				for k in 0..1000
					@log.info "#{Thread.current} #{k}: #{prime_factors(k)}"
				end
			@log.info "#{Thread.current} complete"
		end
	end
	threads.each {|t| t.join}
	@log.info 'thread performace test complete'
end

def getCmd
	while 1
		cmd = gets.chomp.strip.downcase
		case cmd
		when "p"
			startProcesses
			puts "spawning processes.."
			exit
		when "t"
			startThreads
			puts "spawning Threads.."
			exit
		when "b"
			puts 'running ruby benchmark'
			#implement ruby benchmark
			exit
		when "exit"
			exit
		else 
			puts "usage: [p-runs processes|t-runs threads|b-runs Ruby performance testing]"
			puts "Enter command: "
			getCmd
		end
	end
end

puts "Enter command: "
getCmd
