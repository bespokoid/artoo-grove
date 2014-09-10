require 'artoo/drivers/driver'

module Artoo
	module Drivers
		class GroveDht < Driver
			COMMANDS = [:read]
			attr_reader :data

			def read
				puts "read start"
				# connection.digital_read(pin)
				@data.fill 0, 0..5				
				_count = 6
				j = 0
				laststate = 1

				connection.digital_write pin, :high
				sleep 0.25

				#TODO Cache

				connection.digital_write pin, :low
				sleep 0.02
				connection.digital_write pin, :high
				sleep 0.04

				0.upto(85) do |i|
					# puts i
					counter = 0
    			while ((newstate = connection.digital_read(pin)) == laststate)       
    				# puts newstate
    				counter += 1
      			sleep 0.001
      			break if (counter == 255) 
    			end
    			puts "#{i}: Counter: #{counter}. State: #{laststate} => #{newstate}"
    			laststate = newstate

    			break if (counter == 255)

    			# ignore first 3 transitions
			    if ((i >= 4) && (i%2 == 0))
			      # shove each bit into the storage bytes
			      @data[j/8] = @data[j/8] << 1
			      @data[j/8] = @data[j/8] | 1 if (counter > _count)
			      j+=1
			      puts j
			    	puts "data: " + @data[j/8].to_s
			    end
					
				end
				puts "Data: #{@data}"
			end

			def start_driver
				puts "start_driver"
				connection.digital_write(pin, :high)
				@data = []
				super
			end

		end
	end
end