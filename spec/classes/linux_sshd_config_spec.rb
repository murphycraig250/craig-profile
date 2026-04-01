require 'spec_helper'
require 'linux_helper'

describe 'profile::linux_sshd_config' do
  supported_linux.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('profile::linux_sshd_config') }

      it {
        is_expected.to contain_file('/etc/ssh/sshd_config').with(
          'ensure'       => 'file',
          'owner'        => 'root',
          'group'        => 'root',
          'mode'         => '0600',
          'validate_cmd' => '/usr/sbin/sshd -t -f %',
          'notify'       => 'Service[ssh]',
        ).with_content(/PermitRootLogin no/)
      }

      it {
        is_expected.to contain_file('/etc/ssh/sshd_config.d').with(
          'ensure'  => 'directory',
          'recurse' => true,
          'purge'   => true,
          'force'   => true,
        )
      }

      it {
        is_expected.to contain_service('ssh').with(
          'ensure' => 'running',
          'enable' => true,
        )
      }
    end
  end
end
