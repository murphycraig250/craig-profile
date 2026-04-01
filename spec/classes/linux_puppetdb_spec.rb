require 'spec_helper'
require 'linux_helper'

describe 'profile::linux_puppetdb' do
  supported_linux.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:hiera_config) { 'spec/fixtures/hiera.yaml' }
      
      before(:each) do
        File.write('spec/fixtures/hiera.yaml', <<-YAML
---
:backends:
  - yaml
:hierarchy:
  - common
:yaml:
  :datadir: spec/fixtures/hiera
        YAML
        )
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('profile::linux_puppetdb') }
      it { is_expected.to contain_class('puppetdb') }
      it { is_expected.to contain_class('puppetdb::master::config') }
    end
  end
end
