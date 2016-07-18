require_relative '../../itamae_helper'

# create a directory for keep status of itamae
directory status_dir.to_s do
  owner 'root'
  group 'root'
  mode '744'
end

# sort mirror list
package 'reflector'
execute 'reflector --verbose -l 200 -p http --sort rate --save /etc/pacman.d/mirrorlist' do
  not_if 'pacman -Qi reflector'
end

# update system
execute "pacman -Syu --noconfirm && touch #{status_file_path('system_updated')}" do
  not_if "test -e #{status_file_path('system_updated')}"
end

# install yaourt
addition_of_pacman_conf = <<-CONF

[archlinuxfr]
SigLevel = Never
Server = http://repo.archlinux.fr/$arch
CONF

execute "echo #{addition_of_pacman_conf} >> /etc/pacman.conf" do
  not_if 'grep /etc/pacman.conf "[archlinuxfr]"'
end

execute 'pacman --sync --refresh --noconfirm yaourt' do
  not_if 'pacman -Qi yaourt'
end
