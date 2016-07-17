require 'pathname'

USER = node[:user][:name]
HOMEDIR_PATH = Pathname.new('/home') + USER

user USER do
  password node[:user][:password]
  home HOMEDIR_PATH.to_s
end

directory HOMEDIR_PATH.to_s do
  owner USER
  group 'users'
  mode '744'
end

directory (HOMEDIR_PATH + '.ssh').to_s  do
  owner USER
  group 'users'
  mode '700'
end

remote_file (HOMEDIR_PATH + '.ssh' + 'id_rsa.pub').to_s do
  source node[:user][:pubkey]
  owner USER
  group 'users'
  mode '600'
end

remote_file (HOMEDIR_PATH + '.ssh' + 'authorized_keys').to_s do
  source node[:user][:pubkey]
  owner USER
  group 'users'
  mode '600'
end

remote_file (HOMEDIR_PATH + '.ssh' + 'id_rsa').to_s do
  source node[:user][:privatekey]
  owner USER
  group 'users'
  mode '600'
end
