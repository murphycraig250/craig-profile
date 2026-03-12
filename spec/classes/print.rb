require 'spec_helper'

on_supported_os.each do |os, os_facts|
  puts os_facts.inspect # This will dump EVERYTHING the test sees into your terminal
end