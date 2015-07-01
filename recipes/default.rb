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
  revision 'master'
  destination node['openscap']['directory']
  action :sync
end

git 'openscap-security-guide' do
  repository node['scap_security_guide']['git_repository']
  revision 'master'
  destination node['scap_security_guide']['directory']
  action :sync
end

# TODO: Determine most appropriate way to split this into different recipes while staying DRY
open_scap_guide_version = ''
open_scap_guide_dist_dir = ''
case node['platform_family']
when 'rhel'
  if    node['platform_version'].match(/^5/)
    open_scap_guide_version = 'rhel5'
    open_scap_guide_dist_dir = 'RHEL/5'
  elsif node['platform_version'].match(/^6/)
    open_scap_guide_version = 'rhel6'
    open_scap_guide_dist_dir = 'RHEL/6'
  elsif node['platform_version'].match(/^7/)
    open_scap_guide_version = 'rhel7'
    open_scap_guide_dist_dir = 'RHEL/7'
  else
    Chef::Log.error "Cannot build scap-security-guide for '#{node['platform_family']} v#{node['platform_version']}'."
  end
else
  Chef::Log.error "Cannot build scap-security-guide for '#{node['platform_family']}'."
end

# TODO: Determine most appropriate way to split this into different recipes while staying DRY
bash 'make_openscap_guide' do
  user 'root'
  cwd node['scap_security_guide']['directory']
  code <<-EOH
    make #{open_scap_guide_version}
  EOH

  subscribes :run, 'git[openscap-security-guide]', :immediately
  action :nothing
end

bash 'autogen_openscap' do
  user 'root'
  cwd node['openscap']['directory']
  code '(./autogen.sh && ./configure && make)'

  subscribes :run, 'git[openscap]', :immediately
  action :nothing
end
