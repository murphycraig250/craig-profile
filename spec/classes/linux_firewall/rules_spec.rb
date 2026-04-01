require 'spec_helper'
require 'linux_helper'

describe 'profile::linux_firewall::rules' do
  supported_linux.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Need to provide pre and post classes because they are referenced in Firewall defaults
      let(:pre_condition) do
        <<-PUPPET
        include profile::linux_firewall::pre
        include profile::linux_firewall::post
        PUPPET
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('profile::linux_firewall::rules') }

      it { is_expected.to contain_firewall('100 allow ssh access').with_dport(22).with_proto('tcp') }
      it { is_expected.to contain_firewall('101 allow http and https').with_dport([80, 443]) }
      it { is_expected.to contain_firewall('200 block bad actor from containers').with_chain('DOCKER-USER').with_source('192.168.1.105').with_jump('drop') }
    end
  end
end
