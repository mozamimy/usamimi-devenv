module RecipeHelper
  # FIXME: Fix below code after https://github.com/itamae-kitchen/itamae/pull/218 is merged.
  def directory_recursive(source, *paths, &block)
    paths.inject(source) do |acc, x|
      directory (acc + x).to_s, &block
      acc + x
    end
  end
end

Itamae::Recipe::EvalContext.send(:include, RecipeHelper)
