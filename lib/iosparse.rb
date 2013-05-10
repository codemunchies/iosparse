require 'yaml'
#
# IOSParse will parse Cisco IOS configuration files.
#
class IOSParse

	def initialize(filename)
		load_config(filename)
	end

	# Custom filter
	def find_all(custom_filter)
		options = {
			filter: /^#{custom_filter}.+/,
			parent: "#{custom_filter}"
		}
		find_blocks(options)
	end

	# Custom seek
	def has(custom_seek)
		options = {
			filter: /.+#{custom_seek}.+/,
			parent: "#{custom_seek}"
		}
		find_blocks(options)
	end

	# What group is an IP in?
	def group_has_ip(ip)
		options = {
			filter: /^object-group.+#{ip}.+/,
			parent: "#{ip}"
		}
		find_object_group(options)
	end

	private

	def find_blocks(options)
		output = Array.new
		@yaml.each do |line|
			output << line.match(options[:filter]) if line.match(options[:filter])
		end
		normalize(output)
	end

	def find_object_group(options)
		input = Array.new
		output = Array.new
		@yaml.each do |line|
			input << line.match(options[:filter]) if line.match(options[:filter])
		end
		input.each { |rule| output << rule.to_s.split("\s-\s")[0] }
		normalize(output)
	end

	# Load Cisco 'show all' dump
	def load_config(filename)
		@config = File.open(filename, 'r')
		serialize
		load_yaml
		clean_up
	end

	# Load our serialized output
	def load_yaml
		@yaml = YAML::load(File.open('tmp'))
	end

	# Remove our tmp file left behind by serialize()
	def clean_up
		File.delete('tmp')
	end

	# Normalize output
	def normalize(input)
		output = Array.new
		input.each do |line|
			output << line.to_s.gsub("\s-\s",'\n')
		end
		output
	end

	# Serialize load_config(), make YAML compatible
	def serialize
		yaml = File.open('tmp', 'w')
		@config.each do |line|
			case line
			when /^!/
				next
			when /^names/
				next
			when /^\S/
				yaml.puts "\s-\s#{line.gsub("#","*")}"
			when /^\s/
				yaml.puts "\s\s-\s#{line}"
			else
				# TODO: raise an error here 'woops'
			end
		end
	end
end

config = IOSParse.new('../spec/etc/cisco_asa.config')

puts config.group_has_ip('10.10.15.100').class