require 'iosparse'

describe 'IOSParse' do

	before :all do
		@config = IOSParse.new('etc/cisco_asa.config')
	end

	it 'should be an object type IOSParse' do
		@config.is_a?(IOSParse)
	end

	describe 'Interfaces' do
		
		it 'should return an Array object' do
			@config.interfaces.is_a?(Array)
		end

		it 'should return a list of interfaces' do
			@config.interfaces.each { |x| x.include?('interface') }
		end
	end

	describe 'Monitor Interfaces' do

		it 'should return an Array object' do
			@config.monitor_interfaces.is_a?(Array)
		end

		it 'should return a list of monitor interfaces' do
			@config.monitor_interfaces.each { |x| x.include?('monitor-interface') }
		end
	end

	describe 'Names' do

		it 'should return an Array object' do
			@config.names.is_a?(Array)
		end

		it 'should return a list of names' do
			@config.names.each { |x| x.include?('names') }
		end
	end

	describe 'Routes' do

		it 'should return an Array object' do
			@config.routes.is_a?(Array)
		end

		it 'should return a list of routes' do
			@config.routes.each { |x| x.include?('routes') }
		end
	end

	describe 'Access List' do

		it 'should return an Array object' do
			@config.access_list.is_a?(Array)
		end

		it 'should return an access list' do
			@config.access_list.each { |x| x.include?('access-list') }
		end
	end

	describe 'Object Group' do

		it 'should return an Array object' do
			@config.object_groups.is_a?(Array)
		end

		it 'should return a list of object groups' do
			@config.object_groups.each { |x| x.include?('object-group') }
		end
	end
end