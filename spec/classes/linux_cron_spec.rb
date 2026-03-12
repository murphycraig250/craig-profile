require 'spec_helper'

describe 'profile::linux_cron' do
  test_on = {
    supported_os: [
      {
        'operatingsystem' => 'Debian',
        'operatingsystem' => 'RedHat',
      }
    ]
  }
  on_supported_os(test_on).each do |os, os_facts|
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
      it "contains the datetemp job with the correct path for #{os_facts[:osfamily]}" do
        is_expected.to contain_cron__job('datetemp').with({
          'minute'  => '*/5',
          'user'    => 'root',
          'command' => "#{date_path} >> /tmp/cron",
        })
      end
    end
  end
end
