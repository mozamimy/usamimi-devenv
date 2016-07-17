require 'pathname'
require_relative '../../itamae_helper'

SUDOERS_DIR = Pathname.new('/etc/sudoers.d')

user user_name do
  password node[:user][:password]
  home homedir_path.to_s
end

directory homedir_path.to_s do
  owner user_name
  group group_name
  mode '744'
end

directory (homedir_path + '.ssh').to_s  do
  owner user_name
  group group_name
  mode '700'
end

remote_file (homedir_path + '.ssh' + 'id_rsa.pub').to_s do
  source node[:user][:pubkey]
  owner user_name
  group group_name
  mode '600'
end

remote_file (homedir_path + '.ssh' + 'authorized_keys').to_s do
  source node[:user][:pubkey]
  owner user_name
  group group_name
  mode '600'
end

remote_file (homedir_path + '.ssh' + 'id_rsa').to_s do
  source node[:user][:privatekey]
  owner user_name
  group group_name
  mode '600'
end

remote_file '/etc/sudoers' do
  source 'files/etc/sudoers'
  owner 'root'
  group 'root'
  mode '600'
end

[user_name, 'vagrant'].each do |sudoer|
  template (SUDOERS_DIR + sudoer).to_s do
    source 'templates/etc/sudoers.d/user.erb'
    owner 'root'
    group 'root'
    mode '660'
    variables(sudoer: sudoer)
  end
end
