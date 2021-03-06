require_relative '../../itamae_helper'

REPOSITORY_PATH = homedir_path + 'var' + 'repo' + 'private' + 'dotfiles'
RC_FILES = %w(bashrc gitconfig pryrc rbtclk tmux.conf vimperatorrc vimrc)

directory_recursive homedir_path, *%w(var repo private) do
  owner user_name
  group group_name
  mode '744'
end

git REPOSITORY_PATH.to_s do
  repository 'https://github.com/mozamimy/dotfiles.git'
  user user_name
  not_if "test -d #{REPOSITORY_PATH}"
end

# NOTE: Because a passphrase is asked if we use SSH to pull dotfiles repository.
execute 'git remote set-url origin git@github.com:mozamimy/dotfiles.git' do
  user user_name
  cwd REPOSITORY_PATH.to_s
  not_if "git remote -v | grep 'git@github.com:mozamimy/dotfiles.git'"
end

RC_FILES.each do |rc_file|
  link (homedir_path + ".#{rc_file}").to_s do
    user user_name
    to (REPOSITORY_PATH + rc_file).to_s
  end
end

BASH_PROFILE_PATH = homedir_path + '.bash_profile'

execute "echo 'source ~/.bashrc' >> '#{BASH_PROFILE_PATH}'" do
  user user_name
  not_if "cat #{BASH_PROFILE_PATH} | grep 'source ~/.bashrc'"
end
