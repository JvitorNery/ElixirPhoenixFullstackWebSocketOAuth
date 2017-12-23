defmodule Discuss.Repo.Migrations.AddUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :avatar, :string
      add :email, :string
      add :provider, :string
      add :token, :string
      add :login, :string
      timestamps()
    end
  end
end
