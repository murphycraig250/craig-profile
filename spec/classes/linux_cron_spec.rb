require 'spec_helper'
require 'linux_helper'

describe 'profile::linux_cron' do
  supported_linux.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:date_path) do
        if os_facts.dig(:os, 'family') == 'RedHat'
          '/usr/bin/date'
        else
          '/bin/date'
        end
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('profile::linux_cron') }
      it { is_expected.to contain_class('cron') }

      it {
        is_expected.to contain_cron__job('datetemp').with(
          'minute'  => '*/5',
          'user'    => 'root',
          'command' => "#{date_path} >> /tmp/cron",
        )
      }
    end
  end
end
