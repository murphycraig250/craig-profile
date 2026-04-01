require 'spec_helper'
require 'linux_helper'

describe 'profile::linux_motd' do
  supported_linux.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts.merge({
          'networking' => {
            'fqdn' => 'testhost.example.com',
            'ip'   => '192.168.1.1',
          },
          'os' => os_facts[:os].merge({
            'distro' => { 'description' => 'Test OS Description' }
          })
        })
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('profile::linux_motd') }
      
      it {
        is_expected.to contain_class('motd').with_content(
          /HOSTNAME:\s+testhost\.example\.com/
        ).with_content(
          /OS:\s+Test OS Description/
        ).with_content(
          /IP:\s+192\.168\.1\.1/
        )
      }

      it {
        is_expected.to contain_file('/etc/issue').with(
          'ensure'  => 'file',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
          'content' => "Welcome to \\n (\\l)\nAuthorized users only!\n\n",
        )
      }

      it {
        is_expected.to contain_file('/etc/issue.net').with(
          'ensure'  => 'file',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
          'content' => "**********************************************************\n* Authorized Access Only!                                *\n* This system is monitored. Disconnect if unauthorized.  *\n**********************************************************\n",
        )
      }
    end
  end
end
