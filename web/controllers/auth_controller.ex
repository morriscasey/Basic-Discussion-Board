defmodule Discuss.AuthController do
  use Discuss.Web, :controller
  plug Ueberauth

  alias Discuss.User

  # def request(conn, %{"provider" => provider}) do
  #   redirect conn, external: authorize_url!(provider)
  #
  # end

  # def callback(%{ assigns: %{ ueberauth_failure: fails } } = conn, _params) do
  #
  #   fails
  #   |> put_flash(:error, "Failed to authenticate.")
  #   |> redirect(to: "/")
  # end

  def callback(%{ assigns: %{ ueberauth_auth: auth }}= conn, params) do

    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "github"}
    changeset = User.changeset(%User{}, user_params)

    signin(conn, changeset)
  end
  # def callback(conn, %{"provider" => provider, "code" => code}) do
  #
  #   token = get_token!(provider, code)
  #   IO.puts("****")
  #   IO.inspect(token)
  #   IO.puts("*****")
  #   user = get_user!(provider, token)
  #
  #   user_params = %{token: token, email: user, provider: provider}
  #   changeset = User.changeset(%User{}, user_params)
  #
  #   signin(conn, changeset)
  #
  # end

  def signout(conn, _params) do
    
    conn
    |> configure_session(drop: true)
    |> redirect(to: topic_path(conn, :index))
  end

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: topic_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: topic_path(conn, :index))
    end
  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end

  # # # Oauth 2
  # defp authorize_url!("github"), do: GitHub.authorize_url!
  # #defp authorize_url!("google"), do: Google.authorize_url!
  # defp authorize_url!(_), do: raise "No matching provider available"
  #
  # defp get_token!("github", code), do: GitHub.get_token!(code: code)
  # # #defp get_token!("google", code), do: Google.get_token!(code: code)
  # defp get_token!(_, _), do: raise "No matching provider available"
  #
  # defp get_user!("github", token), do: OAuth2.AccessToken.get!(token, "/user")
  # defp get_user!("google", token), do: OAuth2.AccessToken.get!(token, "/user")
end
