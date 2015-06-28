#
# Cookbook Name:: openscap-chef
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'openscap-chef::default' do
  context 'When all attributes are default, on a RHEL6 platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6.5')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end

    it 'installs required packages' do
      packages = %w(
        libacl-devel
        libcap-devel
        libcurl-devel
        libgcrypt-devel
        libselinux-devel
        libxml2-devel
        libxslt-devel
        make
        openldap-devel
        pcre-devel
        perl-XML-Parser
        perl-XML-XPath
        perl-devel
        python-devel
        rpm-devel
        swig
        openscap-utils
        python-lxml
        git
      )
      packages.each do |pkg|
        expect(chef_run).to install_package(pkg)
      end
    end
  end
end
