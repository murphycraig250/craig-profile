require 'spec_helper'
require 'linux_helper'

describe 'profile::linux_firewall::post' do
  supported_linux.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('profile::linux_firewall::post') }

      it { is_expected.to contain_firewall('999 drop all').with_proto('all').with_jump('drop') }
    end
  end
end
