require_relative '../../itamae_helper'

directory_recursive homedir_path, *%w(var repo private) do
  owner user_name
  group group_name
  mode '744'
end
