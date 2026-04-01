require 'spec_helper'
require 'linux_helper'

describe 'profile::linux_firewall::pre' do
  supported_linux.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('profile::linux_firewall::pre') }

      it { is_expected.to contain_firewall('000 accept all icmp').with_proto('icmp').with_jump('accept') }
      it { is_expected.to contain_firewall('001 accept all to lo interface').with_iniface('lo').with_jump('accept') }
      it { is_expected.to contain_firewall('003 accept related established rules').with_state(['RELATED', 'ESTABLISHED']).with_jump('accept') }
    end
  end
end
