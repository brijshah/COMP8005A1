#!/usr/bin/ruby

#-----------------------------------------------------------------------------
#-- SOURCE FILE:    performance.rb - Process vs. Thread Comparison
#--
#-- PROGRAM:        Process vs Thread Application
#--
#-- FUNCTIONS:      
#--                 def prime_factors(i)
#--                 def startProcesses
#--                 def startThreads
#--                 def getCmd
#--
#-- DATE:           January 17, 2015
#--
#--
#-- DESIGNERS:      Brij Shah
#--
#-- PROGRAMMERS:    Brij Shah
#--
#-- NOTES:
#-- This application uses multiple processes and threads on *nix based 
#-- operating systems to measure the performance and effiency of each one.
#----------------------------------------------------------------------------*/

require 'benchmark'
require 'logger'
require 'thread'

#-----------------------------------------------------------------------------
#-- Globals
#----------------------------------------------------------------------------*/
@DEFAULT_WORKERS = 5

@log = Logger.new('log.txt') 
@log2 = Logger.new('ruby_performance.txt')


#-----------------------------------------------------------------------------
#-- FUNCTION:       def prime_factors(i)    
#--
#-- DATE:           January 17, 2015
#--
#-- VARIABLES(S):   i is a number passed in to decompose 
#--
#-- DESIGNERS:      Rosetta Code
#--
#-- PROGRAMMERS:    Rosetta Code
#--
#-- NOTES:
#-- This function returns am array(or collection) which contains the prime
#-- decomposition of a given number, n, greater than 1.
#----------------------------------------------------------------------------*/
def prime_factors(i)
    v = (2..i-1).detect{|j| i % j == 0}
    v ? ([v] + prime_factors(i/v)) : [i]
end

#-----------------------------------------------------------------------------
#-- FUNCTION:       def startProcesses   
#--
#-- DATE:           January 17, 2015
#--
#-- DESIGNERS:      Brij Shah
#--
#-- PROGRAMMERS:    Brij Shah
#--
#-- NOTES:
#-- startProcesses initiates a benchmark of up to 5 processes that continue
#-- to calculate primes of a pregenerated number passed from prime_facors.
#-- All statistics such as time, PID, and prime factors of a given number
#-- are continuiously logged to a specified file.  
#----------------------------------------------------------------------------*/
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

#-----------------------------------------------------------------------------
#-- FUNCTION:       def startThreads   
#--
#-- DATE:           January 17, 2015
#--
#-- DESIGNERS:      Brij Shah
#--
#-- PROGRAMMERS:    Brij Shah
#--
#-- NOTES:
#-- startThreads initiates a benchmark of up to 5 threads that continue to
#-- calculate primes of a pregenerated number passed in from prime_factors.
#-- All statistics such as time, PID, and prime factors of a given number
#-- are continuously logged to a specified file.   
#----------------------------------------------------------------------------*/
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

#-----------------------------------------------------------------------------
#-- FUNCTION:       def getCmd    
#--
#-- DATE:           January 17, 2015
#--
#-- DESIGNERS:      Brij Shah
#--
#-- PROGRAMMERS:    Brij Shah
#--
#-- NOTES:
#-- getCmd function retrieves a command from the user from the command line.
#-- Based on the command received the corresponding function is called to
#-- either start the process test, the thread test, or the Process vs. Thread
#-- benchmark test. If the user enteres 'b', a special benchmark test will be
#-- initiated which will output results to a seperate log file to compare the
#-- results between both.
#----------------------------------------------------------------------------*/
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
			@log2.info 'started Process vs Thread benchmark test'
			@log2.info "Process ++ #{Benchmark.measure{startProcesses}}\n"
			@log2.info "Thread++ #{Benchmark.measure{startThreads}}\n"
			@log2.info 'completed ruby benchmark'
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
