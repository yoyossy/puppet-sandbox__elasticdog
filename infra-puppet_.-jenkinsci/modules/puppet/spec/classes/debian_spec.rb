require 'spec_helper'

describe 'puppet::debian' do
  let(:params) do
    {
      :ensure => 'installed'
    }
  end

  let(:facts) do
    {
      :osfamily       => 'debian',
      :lsbdistcodename => 'lucid'
    }
  end

  it { should include_class 'apt' }
  it { should contain_apt__source 'puppetlabs' }
  it { should contain_package('puppet').
        with_require('Apt::Source[puppetlabs]') }

  context 'with a different version of Puppet' do
    let(:version) { '2.7.13' }
    let(:params) do
      {
        :ensure => version
      }
    end

    it { should contain_package('puppet').with_ensure(version) }
  end
end
