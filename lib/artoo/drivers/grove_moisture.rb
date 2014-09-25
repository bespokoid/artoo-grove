require 'base_sensor'

module Artoo
  module Drivers
    class GroveMoisture < BaseSensor
     
      def read
        if (a = connection.analog_read(pin)) > 0         
          puts a
        end
        a
      end
      
    end
  end
end
