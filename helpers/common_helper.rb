module CommonHelper
  def user_name
    node[:user][:name]
  end

  def group_name
    'users'
  end

  def homedir_path
    Pathname.new('/home') + user_name
  end

  def status_dir
    Pathname.new('/var/itamae_status')
  end

  def status_file_path(file)
    status_dir + file
  end

  def hostname
    node[:host][:name]
  end
end

Itamae::Recipe::EvalContext.include(CommonHelper)
Itamae::Resource::Base::EvalContext.include(CommonHelper)
