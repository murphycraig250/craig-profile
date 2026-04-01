require 'spec_helper'
require 'linux_helper'

describe 'profile::linux_nfsclient' do
  supported_linux.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('profile::linux_nfsclient') }
      it { is_expected.to contain_package('nfs-common').with_ensure('installed') }
      it {
        is_expected.to contain_file('/mnt/network_data').with(
          'ensure' => 'directory',
          'owner'  => 'root',
          'group'  => 'labadmins',
          'mode'   => '0775',
        )
      }
      it {
        is_expected.to contain_mount('/mnt/network_data').with(
          'ensure'  => 'mounted',
          'device'  => 'ubuntu-primary.localdomain:/srv/nfs_share',
          'fstype'  => 'nfs',
          'options' => 'defaults,_netdev',
          'atboot'  => true,
          'require' => ['Package[nfs-common]', 'File[/mnt/network_data]'],
        )
      }
    end
  end
end
