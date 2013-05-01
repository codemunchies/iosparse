class IOSParse

	#
	# Load the configuration file passing IOSParse the filename
	#
	def initialize(filename)
		# Store all blocks in the configuration
		@blocks = Array.new
		# Load the file
		config = File.open(filename, 'r')
		# Stream IO.read the file and scan for blocks, lines inbetween "!"
		IO.read(config).scan(/(^[^!]+)/).each do |block|
			# Push the blocks to the @blocks array
			@blocks << block
		end
	end

	#
	# Find all interfaces
	#
	def interfaces
		# Regex to parse out interfaces
		interfaces = /\["interface[\s\S]+/
		# Call findblocks() passing regex, parent name, and parse boolean
		findblocks(interfaces, "interface", false)
	end

	#
	# Find all names
	#
	def names
		# Regex to parse out names
		names = /\["names[\s\S]+/
		# Call findblocks() passing regex, parent name, and parse boolean
		findblocks(names, "names", false)
	end

	#
	# Find all routes
	#
	def routes
		# Regex to parse out routes
		routes = /\["route[\s\S]+/
		# Call findblocks() passing regex, parent name, and parse boolean
		findblocks(routes, "route", false)
	end

	#
	# Find all access-lists
	#
	def access_list
		# Regex to parse out acl
		acl = /access-list[\s\S]+/
		# Call findblocks() passing regex, parent name, and parse boolean
		findblocks(acl, "access-list", true)
	end

	#
	# Find all object-groups
	#
	def object_group
		# Regex to parse out object-groups
		group = /object-group[\s\S]+/
		# Call findblocks() passing regex, parent name, and parse boolean
		findblocks(group, "object-group", true)
	end

	private

	#
	# Primary method to accept regex and parent, then use them to parse blocks and store them in an Array
	#
	def findblocks(filter, parent, parse)
		# Array to store parsed blocks
		output = Array.new
		@blocks.each do |block|
			# Use regex to filter via scan() and flatten then push to array
			output << block.to_s.scan(filter).flatten if block.to_s.include?(parent)
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
end