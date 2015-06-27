#
# Cookbook Name:: openscap-chef
# Recipe:: default
# Include OS platform speciic package installs

begin
  include_recipe "openscap-chef::_#{node['platform_family']}"
rescue Chef::Exceptions::RecipeNotFound
  Chef::Log.error <<-EOSTDOUT
An openscap recipe does not exist for '#{node['platform_family']}'. This
means the openscap cookbook does not have support for the
#{node['platform_family']} family.
EOSTDOUT
end

directory 'openscap directory' do
  path node['openscap']['directory']
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

directory 'scap-security-guide directory' do
  path node['scap_security_guide']['directory']
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

git 'openscap' do
  repository node['openscap']['git_repository']
  destination node['openscap']['directory']
  action :sync
end

git 'openscap-security-guide' do
  repository node['scap_security_guide']['git_repository']
  destination node['scap_security_guide']['directory']
  action :sync
end

# TODO: Determine most appropriate way to split this into different recipes while staying DRY
open_scap_guide_version = ''
case node['platform_family']
when 'rhel'
  if    node['platform_version'].match(/^5/)
    open_scap_guide_version = 'rhel5'
  elsif node['platform_version'].match(/^6/)
    open_scap_guide_version = 'rhel6'
  elsif node['platform_version'].match(/^7/)
    open_scap_guide_version = 'rhel7'
  else
    Chef::Log.error "This cookbook is not yet configured for '#{node['platform_family']} v#{node['platform_version']}'."
  end
else
  Chef::Log.error "This cookbook is not yet configured for '#{node['platform_family']}'."
end

# TODO: Determine most appropriate way to split this into different recipes while staying DRY
bash 'make_openscap_guide' do
  user 'root'
  cwd node['scap_security_guide']['directory']
  code <<-EOH
    make #{open_scap_guide_version}
  EOH
  action :run
end
