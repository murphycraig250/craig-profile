require 'spec_helper'
require 'linux_helper'

describe 'profile::linux_docker_ward' do
  supported_linux.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('profile::linux_docker_ward') }
      it { is_expected.to contain_class('profile::linux_docker') }

      it {
        is_expected.to contain_file('/srv/ward').with(
          'ensure' => 'directory',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0755',
        )
      }

      it {
        is_expected.to contain_file('/srv/ward/docker-compose.yml').with(
          'ensure' => 'file',
          'source' => 'puppet:///modules/profile/docker/ward-docker-compose.yml',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
        )
      }

      it {
        is_expected.to contain_docker_compose('ward').with(
          'ensure'        => 'present',
          'compose_files' => ['/srv/ward/docker-compose.yml'],
        )
      }
    end
  end
end
