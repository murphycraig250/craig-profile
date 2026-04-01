require 'spec_helper'
require 'linux_helper'

describe 'profile::linux_puppetboard' do
  supported_linux.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('profile::linux_puppetboard') }
      it { is_expected.to contain_package('python3.10-venv').with_ensure('installed') }
      
      it {
        is_expected.to contain_class('puppetboard').with(
          'python_version' => '3.10',
          'puppetdb_host'  => 'ubuntu-primary.localdomain',
          'require'        => 'Package[python3.10-venv]',
        )
      }
    end
  end
end
