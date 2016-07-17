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
end

RC_FILES.each do |rc_file|
  link (homedir_path + ".#{rc_file}").to_s do
    user user_name
    to (REPOSITORY_PATH + rc_file).to_s
  end
end
