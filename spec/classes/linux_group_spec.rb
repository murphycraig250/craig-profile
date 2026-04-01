require 'spec_helper'
require 'linux_helper'

describe 'profile::linux_group' do
  supported_linux.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts.merge({
          'networking' => { 'hostname' => 'testhost' }
        })
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('profile::linux_group') }
      it { is_expected.to contain_class('accounts') }
      it {
        is_expected.to contain_class('sudo').with(
          'config_file_replace' => false,
          'purge'               => true,
          'purge_ignore'        => ['vagrant', 'README'],
        )
      }

      it { is_expected.to contain_group('testhost_group').with_ensure('present') }

      it {
        is_expected.to contain_sudo__conf('labadmins').with(
          'priority' => 10,
          'content'  => '%labadmins ALL=(ALL) NOPASSWD: ALL',
        )
      }

      context 'with custom groups' do
        let(:params) do
          {
            'group_list' => {
              'devgroup' => { 'ensure' => 'present' },
              'testgroup' => { 'ensure' => 'absent' },
            }
          }
        end

        it { is_expected.to contain_group('devgroup').with_ensure('present') }
        it { is_expected.to contain_group('testgroup').with_ensure('absent') }
      end
    end
  end
end
