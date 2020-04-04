defmodule BlogWeb.PageController do
  use BlogWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", posts: Blog.Blog.list_posts())
  end

  def post(conn, %{"id" => id}) do
    # Find post from memory by id
    post = Blog.Blog.find_post(id)

    # Render with post meta information
    render(conn, "post.html", post: post, feature_image: post.featureimage, title: post.title)
  end
end
