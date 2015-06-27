#
# Cookbook Name:: openscap-chef
# Recipe:: default
#
# Copyright (c) 2015 ADV, All Rights Reserved.

# Include OS platform speciic package installs
begin
  include_recipe "openscap-chef::_#{node['platform_family']}"
rescue Chef::Exceptions::RecipeNotFound
  Chef::Log.error <<-EOSTDOUT
An adv_base recipe does not exist for '#{node['platform_family']}'. This
means the adv_base cookbook does not have support for the
#{node['platform_family']} family.
EOSTDOUT
end

directory 'openscap directory' do
  path        node['openscap']['directory']
  owner       'root'
  group       'root'
  mode        '0755'
  recursive   true
  action      :create
end

directory 'scap-security-guide directory' do
  path        node['scap_security_guide']['directory']
  owner       'root'
  group       'root'
  mode        '0755'
  recursive   true
  action      :create
end

git 'openscap' do
  repository   node['openscap']['git_repository']
  destination  node['openscap']['directory']
  action       :sync
end

git 'openscap-security-guide' do
  repository   node['scap_security_guide']['git_repository']
  destination  node['scap_security_guide']['directory']
  action       :sync
end
