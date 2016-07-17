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
end

Itamae::Recipe::EvalContext.include(CommonHelper)
Itamae::Resource::Base::EvalContext.include(CommonHelper)
