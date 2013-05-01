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
	# Find the interfaces in the configuration file
	#
	def interfaces
		# Regex to parse out interfaces
		interfaces = /\["interface[\s\S]+/
		# Call findblocks() passing the regex and parent
		findblocks(interfaces, "interface")
	end

	#
	# Find all names in the configuration file
	#
	def names
		# Regex to parse out names
		names = /\["names[\s\S]+/
		# Call findblocks() passing regex and parent
		findblocks(names, "names")
	end

	#
	# Find all ACL
	#
	def access_list
		# Regex to parse out acl
		acl = /\["access-list[\s\S]+/
		# Call findblocks() passing regex and parent
		findblocks(acl, "access-list")
	end

	#
	# Find all objects-groups
	#
	def object_group
		# Regex to parse out object-groups
		group = /object-group[\s\S]+/
		# Call findblocks() passing regex and parent
		findblocks(group, "object-group")
	end

	private

	#
	# Primary method to accept regex and parent, then use them to parse blocks and store them in an Array
	#
	def findblocks(filter, parent)
		# Array to store parsed blocks
		output = Array.new
		@blocks.each do |block|
			# Use regex to filter via scan() and flatten then push to array
			output << block.to_s.scan(filter).flatten if block.to_s.include?(parent)
		end
		# Object-groups are not within "!" blocks and require some extra work
		if parent == "object-group" then
			parse_object_group(clean_object_group(output))
		else
			# Return the parsed block as an array
			output
		end
	end

	#
	# Remove extra characters from object-groups
	#
	def clean_object_group(block)
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
	# Object-groups come as a single string, we break each object-group into a string and push into an array
	#
	def parse_object_group(block)
		# Array to store parsed blocks
		output = Array.new
		block.each do |line|
			# Split the line where each object-group begins
			line.to_s.split("object-group").each do |push|
				# Skip empty lines
				next if push.include?('["')
				# Remove extra "] characters from each line
				push = push.gsub('"]', '')
				# Re-add object-group to the beginning of the line and push it into the array line-by-line
				output << "[\"object-group#{push}\"]"
			end
		end
		# Return the parsed block as an array
		output
	end
end