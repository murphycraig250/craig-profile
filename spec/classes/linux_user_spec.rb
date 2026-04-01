require 'spec_helper'
require 'linux_helper'

describe 'profile::linux_user' do
  supported_linux.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts.merge({
          'networking' => { 'hostname' => 'testhost' }
        })
      end
      
      # Provide user_list as a parameter to avoid Hiera lookup and eyaml errors
      let(:params) do
        {
          'user_list' => {}
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('profile::linux_user') }
      it { is_expected.to contain_class('accounts') }

      it {
        is_expected.to contain_accounts__user('testhost_user').with(
          'ensure' => 'present',
          'locked' => false,
          'groups' => ['testhost_group', 'users', 'labadmins'],
        )
      }

      context 'with custom users' do
        let(:params) do
          {
            'user_list' => {
              'devuser' => { 'ensure' => 'present', 'groups' => ['devs'] }
            }
          }
        end

        it { is_expected.to contain_accounts__user('devuser').with_ensure('present') }
      end
    end
  end
end
