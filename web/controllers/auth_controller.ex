defmodule Discuss.AuthController do
    use Discuss.Web, :controller
    plug Ueberauth

    alias Discuss.User

    def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
        user_params = %{
            name: auth.info.name,
            avatar: auth.info.image,
            email: auth.info.email,
            provider: "github",
            token: auth.credentials.token,
            login: auth.info.nickname
        }

            changeset = User.changeset(%User{}, user_params)
            
            signin(conn, changeset)

        conn
        |> redirect(to: topic_path(conn, :index))
    end

    defp insert_or_update_user(changeset) do
        case Repo.get_by(User, email: changeset.changes.email) do
            nil ->
                Repo.insert(changeset)
                user ->
                    {:ok, user}
        end
    end

    defp signin(conn, changeset) do
        case insert_or_update_user(changeset) do
            {:ok, user} ->
                conn
                |> put_flash(:info, "Signing in Successful")
                |> put_session(:user_id, user.id)
                |> redirect(to: topic_path(conn, :index))
            {:error, _reason} ->
                conn
                |> put_flash(:error, "Signing in failed")
                |> redirect(to: topic_path(conn, :index))
        end
    end

    def signout(conn, _params) do
        conn
        |> put_flash(:info, "Signing out Successful")
        |> configure_session(drop: true)
        # |> put_session(:user_id, nil)
        |> redirect(to: topic_path(conn, :index))
    end

end