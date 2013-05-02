class IOSParse

	#
	# Load the configuration file passing IOSParse the filename
	#
	def initialize(filename)
		# Store all blocks in the configuration
		@blocks = Array.new
		# Load the file
		begin
			config = File.open(filename, 'r')
			# Stream IO.read the file and scan for blocks, lines inbetween "!"
			IO.read(config).scan(/(^[^!]+)/).each do |block|
				# Push the blocks to the @blocks array
				@blocks << block
			end
		rescue
			# TODO: raise an error here 'bad file or path'
		ensure
			# Make sure we close the file
			config.close
		end
	end

	#
	# Find all interfaces
	#
	def interfaces
		# Regex to parse out interfaces
		interfaces = /\["interface[\s\S]+/
		# Call find_blocks() passing regex, parent name, and parse boolean
		find_blocks(interfaces, "interface", false)
	end

	#
	# Find all interfaces in monitor mode
	#
	def monitor_interfaces
		# Regex to parse out the monitor interfaces
		interfaces = /monitor-interface.+/
		# Call find_lines() passing regex, parent name, and parse boolean
		find_lines(interfaces, "monitor-interface", false)
	end

	#
	# Find all names
	#
	def names
		# Regex to parse out names
		names = /\["names[\s\S]+/
		# Call find_blocks() passing regex, parent name, and parse boolean
		find_blocks(names, "names", false)
	end

	#
	# Find all routes
	#
	def routes
		# Regex to parse out routes
		routes = /\["route[\s\S]+/
		# Call find_blocks() passing regex, parent name, and parse boolean
		find_blocks(routes, "route", false)
	end

	#
	# Find all access-lists
	#
	def access_list
		# Regex to parse out acl
		acl = /access-list[\s\S]+/
		# Call find_blocks() passing regex, parent name, and parse boolean
		find_blocks(acl, "access-list", true)
	end

	#
	# Find all object-groups
	#
	def object_groups
		# Regex to parse out object-groups
		group = /object-group[\s\S]+/
		# Call find_blocks() passing regex, parent name, and parse boolean
		find_blocks(group, "object-group", true)
	end

	private

	#
	# Primary method to accept regex and parent, then use them to parse blocks and store them in an Array
	#
	def find_blocks(filter, parent, parse)
		# Array to store parsed blocks
		output = Array.new
		@blocks.each do |block|
			# Use regex to filter via scan() and flatten then push to array
			output << normalize_block(block.to_s.scan(filter).flatten) if block.to_s.include?(parent)
		end
		# Some parents are not within "!" blocks and require some extra work
		if parse == true then
			parse_parent(clean_parent(output), parent)
		else
			# Return the parsed block as an array
			output
		end
	end

	#
	# Primary method to accept regex and parent, then use them to parse lines and store them in an Array
	#
	def find_lines(filter, parent, parse)
		# Array to store parsed blocks
		output = Array.new
		@blocks.each do |block|
			# Use regex to filter via scan() then split each line
			block.to_s.match(filter).to_s.split('\n').each do |line|
				# Skip unless the parent is in the line
				next unless line.match(filter)
				# Push matches to array and normalize the matched lines
				output << normalize_line(line.match(filter))
			end
		end
		# Return the parsed block as an array
		output
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
		# Return the parsed block as an array
		output
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
		# Return the parsed block as an array
		output
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