defmodule Blog.Blog do
  alias Blog.Blog.Post

  for app <- [:earmark, :makeup_elixir] do
    Application.ensure_all_started(app)
  end

  posts_paths = "posts/**/*.md" |> Path.wildcard() |> Enum.sort()

  posts =
    for post_path <- posts_paths do
      @external_resource Path.relative_to_cwd(post_path)
      Post.parse!(post_path)
    end

  @posts Enum.sort_by(posts, & &1.date, {:desc, Date})

  def list_posts do
    @posts
  end

  def find_post(id) do
    Enum.find(@posts, fn post -> Map.get(post, :id) == id end)
  end
end
