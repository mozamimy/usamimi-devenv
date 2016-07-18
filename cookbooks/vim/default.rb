require_relative '../../itamae_helper'

BUNDLE_DIR = homedir_path + '.vim' + 'bundle'

package 'vim'

%w(backup swap).each do |dir|
  directory_recursive homedir_path, *['.vim', dir] do
    owner user_name
    group group
    mode '744'
  end
end

execute 'curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh > install.sh && chmod +x install.sh && sh ./install.sh && rm install.sh' do
  cwd '/tmp'
  user user_name
  not_if "test -d #{BUNDLE_DIR}"
end

# FIXME: below code is not functional, so we should install plugins when vim launch
# execute 'vim +":NeoBundleInstall" +:q' do
#   user user_name
#   not_if "test -d #{BUNDLE_DIR + 'NeoBundle.lock'}"
# end
