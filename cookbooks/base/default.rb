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
  not_if 'cat /etc/pacman.conf | grep "\[archlinuxfr\]"'
end

execute 'pacman --sync --refresh --noconfirm yaourt' do
  not_if 'pacman -Qi yaourt'
end

# set locale
execute 'timedatectl set-timezone Asia/Tokyo' do
  not_if 'timedatectl status | grep JST'
end

execute 'sed -i -e "s/^en_AU.UTF-8 UTF-8/#en_AU.UTF-8 UTF-8/" /etc/locale.gen' do
  only_if 'cat /etc/locale.gen | grep -E "^en_AU.UTF-8 UTF-8"'
end

execute 'sed -i -e "s/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen' do
  only_if 'cat /etc/locale.gen | grep -E "^#en_US.UTF-8 UTF-8"'
end

execute "locale-gen && touch #{status_file_path('locale-generated')}" do
  not_if "test -e #{status_file_path('locale-generated')}"
end

# set hostname
execute "hostname #{hostname}" do
  not_if "hostname | grep #{hostname}"
end

execute "echo '#{hostname}' > /etc/hostname" do
  not_if "cat /etc/hostname | grep #{hostname}"
end

execute "echo -e '\n127.0.0.1 #{hostname}' >> /etc/hosts" do
  not_if "cat /etc/hosts | grep #{hostname}"
end
