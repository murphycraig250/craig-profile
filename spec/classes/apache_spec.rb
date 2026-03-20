# frozen_string_literal: true

require 'spec_helper'
require 'linux_helper'

describe 'profile::apache' do
  supported_linux.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
    end
  end
end
