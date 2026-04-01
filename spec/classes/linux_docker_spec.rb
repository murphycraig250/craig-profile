require 'spec_helper'
require 'linux_helper'

describe 'profile::linux_docker' do
  supported_linux.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('profile::linux_docker') }
      it {
        is_expected.to contain_class('docker').with(
          'dns' => '8.8.8.8',
        )
      }
    end
  end
end
