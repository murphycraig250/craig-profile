require 'spec_helper'
require 'linux_helper'

describe 'profile::linux_docker_pihole' do
  supported_linux.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('profile::linux_docker_pihole') }

      it {
        is_expected.to contain_ini_setting('systemd_resolved_stub_listener').with(
          'ensure'  => 'present',
          'path'    => '/etc/systemd/resolved.conf',
          'section' => 'Resolve',
          'setting' => 'DNSStubListener',
          'value'   => 'no',
          'notify'  => 'Service[systemd-resolved]',
        )
      }

      it {
        is_expected.to contain_service('systemd-resolved').with(
          'ensure' => 'running',
          'enable' => true,
        )
      }

      ['/srv/pihole', '/srv/pihole/etc-pihole', '/srv/pihole/etc-dnsmasq.d'].each do |dir|
        it {
          is_expected.to contain_file(dir).with(
            'ensure' => 'directory',
            'owner'  => 'root',
            'group'  => 'root',
            'mode'   => '0755',
          )
        }
      end

      it {
        is_expected.to contain_file('/srv/pihole/.env').with(
          'ensure'    => 'file',
          'owner'     => 'root',
          'group'     => 'root',
          'mode'      => '0600',
          'show_diff' => false,
          'require'   => 'File[/srv/pihole]',
        )
      }

      it {
        is_expected.to contain_file('/srv/pihole/docker-compose.yml').with(
          'ensure'  => 'file',
          'source'  => 'puppet:///modules/profile/docker/pihole-docker-compose.yml',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
          'require' => 'File[/srv/pihole]',
        )
      }

      it {
        is_expected.to contain_docker_compose('pihole').with(
          'ensure'        => 'present',
          'compose_files' => ['/srv/pihole/docker-compose.yml'],
          'require'       => ['File[/srv/pihole/docker-compose.yml]', 'File[/srv/pihole/.env]'],
          'subscribe'     => ['File[/srv/pihole/docker-compose.yml]', 'File[/srv/pihole/.env]'],
        )
      }
    end
  end
end
