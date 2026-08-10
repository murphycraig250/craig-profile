# frozen_string_literal: true

require 'spec_helper'

describe 'profile::base_windows' do
  on_supported_os.each do |os, os_facts|
    # Skip Windows catalog compilation on non-Windows test hosts (like Linux CI)
    # because the windows_adsi provider for the group resource requires Windows APIs.
    next if os_facts[:os]['family'] == 'windows' && !Gem.win_platform?

    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
    end
  end
end
