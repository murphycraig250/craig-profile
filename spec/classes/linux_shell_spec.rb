require 'spec_helper'
require 'linux_helper'

describe 'profile::linux_shell' do
  supported_linux.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('profile::linux_shell') }

      it {
        is_expected.to contain_file('/etc/profile.d/puppet_shortcuts.sh').with(
          'ensure' => 'file',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
        ).with_content(
          /export PATH="\$PATH:\/opt\/puppetlabs\/bin"/
        ).with_content(
          /alias pa='sudo \/opt\/puppetlabs\/bin\/puppet agent --test'/
        )
      }
    end
  end
end
