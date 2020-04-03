defmodule BlogWeb.PageController do
  use BlogWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", posts: Blog.Blog.list_posts())
  end

  def post(conn, %{"id" => id}) do
    render(conn, "post.html", post: Blog.Blog.find_post(id))
  end
end
