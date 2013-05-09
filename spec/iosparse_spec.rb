require 'iosparse'
require 'spec_helper'

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
			@config.interfaces.each { |x| x.to_s.include?('interface') }
		end
	end

	describe 'Monitor Interfaces' do

		it 'should return an Array object' do
			@config.monitor_interfaces.is_a?(Array)
		end

		it 'should return a list of monitor interfaces' do
			@config.monitor_interfaces.each { |x| x.to_s.include?('monitor-interface') }
		end
	end

	describe 'Names' do

		it 'should return an Array object' do
			@config.names.is_a?(Array)
		end

		it 'should return a list of names' do
			@config.names.each { |x| x.to_s.include?('names') }
		end
	end

	describe 'Routes' do

		it 'should return an Array object' do
			@config.routes.is_a?(Array)
		end

		it 'should return a list of routes' do
			@config.routes.each { |x| x.to_s.include?('routes') }
		end
	end

	describe 'Access List' do

		it 'should return an Array object' do
			@config.access_lists.is_a?(Array)
		end

		it 'should return an access list' do
			@config.access_lists.each { |x| x.to_s.include?('access-list') }
		end
	end

	describe 'Object Group' do

		it 'should return an Array object' do
			@config.object_groups.is_a?(Array)
		end

		it 'should return a list of object groups' do
			@config.object_groups.each { |x| x.to_s.include?('object-group') }
		end
	end

	describe 'Find #{custom}' do

		it 'should return an Array object' do
			@config.find('interface').is_a?(Array)
		end

		it 'should return a list of #{custom}' do
			@config.find('interface').each { |x| x.to_s.include?('interface') }
		end
	end
end
