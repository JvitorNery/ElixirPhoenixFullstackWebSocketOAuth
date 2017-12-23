defmodule Discuss.User do
    use Discuss.Web, :model

    @derive {Poison.Encoder, only: [:name, :email, :avatar]}

    schema "users" do
        field :name, :string
        field :avatar, :string
        field :email, :string
        field :provider, :string
        field :token, :string
        field :login, :string
        has_many :topics, Discuss.Topic
        has_many :comments, Discuss.Comment

        timestamps()
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:name, :avatar, :email, :provider, :token, :login])
        |> validate_required([:name, :avatar, :email, :provider, :token, :login])
    end
end