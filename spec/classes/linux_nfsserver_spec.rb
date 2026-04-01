require 'spec_helper'
require 'linux_helper'

describe 'profile::linux_nfsserver' do
  supported_linux.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('profile::linux_nfsserver') }
      it { is_expected.to contain_package('nfs-kernel-server').with_ensure('installed') }
      it { is_expected.to contain_service('nfs-kernel-server').with_ensure('running') }
      
      it {
        is_expected.to contain_file('/srv/nfs_share').with(
          'ensure' => 'directory',
          'owner'  => 'root',
          'group'  => 'labadmins',
          'mode'   => '0775',
        )
      }

      it {
        is_expected.to contain_file_line('nfs_export_config').with(
          'path' => '/etc/exports',
          'line' => '/srv/nfs_share  *(rw,sync,no_subtree_check)',
        )
      }

      it { is_expected.to contain_exec('update_nfs_exports').with_command('/usr/sbin/exportfs -a') }
    end
  end
end
