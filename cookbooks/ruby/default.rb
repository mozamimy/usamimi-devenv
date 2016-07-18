require_relative '../../itamae_helper'

include_recipe 'rbenv::user'

execute 'echo \'export PATH="$HOME/.rbenv/bin:$PATH"\' >> ~/.bash_profile' do
  user user_name
  not_if 'cat ~/.bash_profile | grep "rbenv"'
end

execute 'echo \'eval "$(rbenv init -)"\' >> ~/.bash_profile' do
  user user_name
  not_if 'cat ~/.bash_profile | grep "rbenv init"'
end
