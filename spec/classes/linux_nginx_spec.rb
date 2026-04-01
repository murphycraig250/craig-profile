require 'spec_helper'
require 'linux_helper'

describe 'profile::linux_nginx' do
  supported_linux.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('profile::linux_nginx') }

      it { is_expected.to contain_package('nginx').with_ensure('installed') }

      it {
        is_expected.to contain_file('/var/www/html/index.html').with(
          'ensure'  => 'file',
          'content' => "<h1>Managed by Puppet</h1>\n",
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
          'notify'  => 'Service[nginx]',
        )
      }

      it {
        is_expected.to contain_service('nginx').with(
          'ensure'    => 'running',
          'enable'    => true,
          'subscribe' => 'Package[nginx]',
        )
      }
    end
  end
end
