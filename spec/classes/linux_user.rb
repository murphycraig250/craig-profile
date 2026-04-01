require 'spec_helper'

describe 'profile::linux_user' do
  on_supported_os(supported_linux).each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts.merge({
          networking: {
            hostname: 'testhost',
          }
        })
      end

      context 'with default parameters' do
        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_class('accounts') }

        it 'creates the host-specific user' do
          is_expected.to contain_accounts__user('testhost_user').with(
            ensure: 'present',
            locked: false,
            groups: ['testhost_group', 'users', 'labadmins'],
            sshkeys: [ /ssh-rsa/ ],
          )
        end
      end

      context 'with additional users' do
        let(:params) do
          {
            user_list: {
              'alice' => {
                'ensure' => 'present',
                'groups' => ['users'],
              },
              'bob' => {
                'ensure' => 'present',
                'groups' => ['labadmins'],
              }
            }
          }
        end

        it { is_expected.to compile.with_all_deps }

        it 'creates the host-specific user' do
          is_expected.to contain_accounts__user('testhost_user')
        end

        it 'creates additional users from user_list' do
          is_expected.to contain_accounts__user('alice').with(
            ensure: 'present',
            groups: ['users'],
          )

          is_expected.to contain_accounts__user('bob').with(
            ensure: 'present',
            groups: ['labadmins'],
          )
        end
      end

      context 'with empty user_list' do
        let(:params) { { user_list: {} } }

        it { is_expected.to compile.with_all_deps }

        it 'only creates the host-specific user' do
          is_expected.to contain_accounts__user('testhost_user')
          is_expected.not_to contain_accounts__user('alice')
          is_expected.not_to contain_accounts__user('bob')
        end
      end
    end
  end
end