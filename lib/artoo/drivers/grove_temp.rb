$:.unshift File.dirname(__FILE__)
require 'base_sensor'

module Artoo
  module Drivers
    class GroveTemp < BaseSensor
      # COMMANDS = [:read, :lower, :upper, :previous_read, :unit].freeze
      B = 3975                  # B value of the thermistor

      # attr_reader :lower, :upper, :previous_read, :unit

      def read
        if (a = connection.analog_read(pin)) > 0         
          resistance = (1023.00-a)*10000/a # get the resistance of the sensor
          temperature = 1/(Math.log(resistance/10000)/B+1/298.15)-273.15 # convert to temperature via datasheet
          temperature = temperature*1.8+32 if @unit == :F # convert to Fahrenheit
          temperature = temperature.round(@precision)
        end
        temperature
      end

      # def start_driver
      #   @previous_read = 0
      #   @upper = additional_params[:upper].nil? ? 1023 : additional_params[:upper]
      #   @lower = additional_params[:lower].nil? ? 0 : additional_params[:lower]
      #   @unit = additional_params[:unit].nil? ? :C : additional_params[:unit].upcase
      #   @precision = additional_params[:precision].nil? ? 2 : additional_params[:precision]

      #   every(interval) do
      #     new_value = read
      #     update(new_value) unless new_value.nil?
      #   end if !interval.nil? and interval > 0

      #   super
      # end

      # private
      
      # def update(new_val)
      #   @previous_read = new_val
      #   if new_val >= @upper
      #     publish(event_topic_name("update"), "upper", new_val)
      #     publish(event_topic_name("upper"), new_val)
      #   elsif new_val <= @lower
      #     publish(event_topic_name("update"), "lower", new_val)
      #     publish(event_topic_name("lower"), new_val)
      #   end
      # end
  
    end
  end
end
