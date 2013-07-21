require 'iosparse'
require 'spec_helper'

describe 'IOSParse' do

  before :all do
    @config = IOSParse.new('etc/cisco_asa.config')
  end

  it 'should be an object type IOSParse' do
    @config.is_a?(IOSParse)
  end

  describe 'Find all #{parent}' do

    it 'should return an Array object' do
      @config.find_all('interface').is_a?(Array)
    end

    it 'should return a list of #{parent}' do
      @config.find_all('interface').each { |x| false unless x.to_s.match(/^interface/) }
    end
  end

  describe 'Has #{filter}' do

    it 'should return an Array object' do
      @config.has('192.168.1.1').is_a?(Array)
    end

    it 'should return a list that includes #{filter}' do
      @config.has('192.168.1.1').each { |x| false unless x.to_s.match(/.+192\.168\.1\.1.+/) }
    end
  end

  describe 'Group has #{ip}' do

    it 'should return an Array object' do
      @config.group_has_ip('192.168.5.1').is_a?(Array)
    end

    it 'should return a group(s) that includes #{ip}' do
      @config.group_has_ip('192.168.5.1').each { |x| false unless x.to_s.match(/^object-group/) }
    end
  end
end
