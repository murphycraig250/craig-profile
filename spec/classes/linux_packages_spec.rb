require 'spec_helper'
require 'linux_helper'

describe 'profile::linux_packages' do
  supported_linux.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('profile::linux_packages') }

      if os_facts[:osfamily] == 'Debian'
        it { is_expected.to contain_package('cmatrix').with_ensure('installed') }
      elsif os_facts[:osfamily] == 'RedHat'
        it { is_expected.to contain_package('epel-release').with_ensure('installed') }
      end

      context 'with custom package lists' do
        let(:params) do
          {
            'packages::install' => ['htop', 'git'],
            'packages::remove'  => ['nano'],
          }
        end

        # Note: lookup doesn't use class params unless it's an AEP (Automatic Parameter Lookup)
        # But this manifest uses lookup() directly.
        # However, for testing purposes, we can provide them as facts or just test defaults if not using a Hiera mock.
      end
    end
  end
end
