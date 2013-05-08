#
# IOSParse will parse Cisco IOS configuration files.
#
class IOSParse
	# Load the configuration file passing IOSParse the filename
	def initialize(filename)
		# Store all blocks in the configuration
		@blocks = Array.new
		begin
			config = File.open(filename, 'r')
			# Stream IO.read the file and scan for blocks, lines inbetween "!"
			IO.read(config).scan(/(^[^!]+)/).each do |block|
				@blocks << block
			end
		rescue
			# TODO: raise an error here 'bad file or path'
		ensure
			config.close
		end
	end

	# Find all interfaces
	def interfaces
		interface = {
			filter: /\["interface[\s\S]+/,
			parent: "interface",
			parse: false,
			normalize: false
		}
		find_blocks(interface)
	end

	# Find all interfaces in monitor mode
	def monitor_interfaces
		monitor_interface = {
			filter: /monitor-interface[\s\S]+/,
			parent: "monitor-interface",
			parse: false,
			normalize: false
		}
		find_lines(monitor_interface)
	end

	# Find all names
	def names
		name = {
			filter: /\["names[\s\S]+/,
			parent: "names",
			parse: false,
			normalize: false
		}
		find_blocks(name)
	end

	# Find all routes
	def routes
		route = {
			filter: /\["route[\s\S]+/,
			parent: "route",
			parse: false,
			normalize: false
		}
		find_blocks(route)
	end

	# Find all access-lists
	def access_list
		acl = {
			filter: /access-list[\s\S]+/,
			parent: "access-list",
			parse: true,
			normalize: true
		}
		find_blocks(acl)
	end

	# Find all object-groups
	def object_groups
		object_group = {
			filter: /object-group[\s\S]+/,
			parent: "object-group",
			parse: true,
			normalize: true
		}
		find_blocks(object_group)
	end

	private

	# Use passed options hash to parse blocks and store them in an Array
	def find_blocks(options)
		# Array to store parsed blocks
		output = Array.new
		@blocks.each do |block|
			# Use regex to filter via scan() and flatten then push to array
			if options[:normalize]
				output << normalize_block(block.to_s.scan(options[:filter]).flatten) if block.to_s.include?(options[:parent])
			else
				output << block.to_s.scan(options[:filter]).flatten if block.to_s.include?(options[:parent])
			end
		end
		# Some parents are not within "!" blocks and require some extra work
		if options[:parse]
			parse_parent(clean_parent(output), options[:parent])
		else
			output
		end
	end

	# Use passed options hash to parse lines and store them in an Array
	def find_lines(options)
		# Array to store parsed blocks
		output = Array.new
		@blocks.each do |block|
			# Use regex to filter via scan() then split each line
			block.to_s.match(options[:filter]).to_s.split('\n').each do |line|
				# Skip unless the parent is in the line
				next unless line.match(options[:filter])
				# Push matches to array and normalize the matched lines
				if options[:normalize]
					output << normalize_line(line.match(options[:filter]))
				else
					output << line.match(options[:filter])
				end
			end
		end
	end

	#
	# Remove extra characters from parents
	#
	def clean_parent(block)
		# Array to store parsed blocks
		output = Array.new
		block.each do |line| 
			# Remove extra "] characters from each line
			output << line.to_s.gsub('\"]', '')
		end
	end

	#
	# Some parents come as a single string, we break each parent into a string and push into an array
	#
	def parse_parent(block, parent)
		# Array to store parsed blocks
		output = Array.new
		block.each do |line|
			# Split the line where each parent begins
			line.to_s.split(parent).each do |data|
				# Skip empty lines
				next if data.include?('["')
				# Remove extra "] characters from each line
				data = data.gsub('"]', '')
				# Re-add parent to the beginning of the line and push it into the array line-by-line
				output << "[\"#{parent}#{data}\"]"
			end
		end
	end

	#
	# Normalize block to standardize returned arrays
	# All new line characters should be '\n'
	#
	def normalize_block(data)
		# Return normalized data
		data.to_s.gsub("\\\\n", '\n') if data.to_s.include?('\\\\n')
	end

	#
	# Normalize line to standardize returned arrays
	# All new line characters should be '\n'
	#
	def normalize_line(data)
		# Return normalized data
		"[\"#{data}\\n\"]" unless data.to_s.include?('\n')
	end
end