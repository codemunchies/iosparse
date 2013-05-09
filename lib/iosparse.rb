require 'yaml'
#
# IOSParse will parse Cisco IOS configuration files.
#
class IOSParse

	def initialize(filename)
		load_config(filename)
	end

	# Custom filter
	def find(custom_filter)
		options = {
			filter: /^#{custom_filter}.+/,
			parent: "#{custom_filter}"
		}
		find_blocks(options)
	end

	# Find all interfaces
	def interfaces
		options = {
			filter: /^interface.+/,
			parent: "interface"
		}
		find_blocks(options)
	end

	# Find all monitor-interfaces
	def monitor_interfaces
		options = {
			filter: /^monitor-interface.+/,
			parent: "monitor-interface"
		}
		find_blocks(options)
	end

	# Find all access-lists
	def access_lists
		options = {
			filter: /^access-list.+/,
			parent: "access-list"
		}
		find_blocks(options)
	end

	# Find all names
	def names
		options = {
			filter: /^name.+/,
			parent: "name"
		}
		find_blocks(options)
	end

	# Find all routes
	def routes
		options = {
			filter: /^route[^r].+/,
			parent: "route"
		}
		find_blocks(options)
	end

	# Find all object-groups
	def object_groups
		options = {
			filter: /^object-group.+/,
			parent: "object-group"
		}
		find_blocks(options)
	end

	private

	def find_blocks(options)
		output = Array.new
		@yaml.each do |line|
			output << line.match(options[:filter]) if line.match(options[:filter])
		end
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