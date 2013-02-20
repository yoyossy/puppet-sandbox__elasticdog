require 'spec_helper'

describe 'puppet' do
  let(:params) do
    {
      :ensure => 'installed'
    }
  end

  context 'on debian systems' do
    let(:facts) do
      {
        :osfamily => 'debian',
        :lsbdistcodename => 'lucid'
      }
    end

    it { should include_class 'puppet::debian' }
  end

  context 'on redhat systems' do
    let(:facts) do
      {
        :osfamily => 'redhat'
      }
    end

    it { should_not include_class 'puppet::debian' }
  end
end
