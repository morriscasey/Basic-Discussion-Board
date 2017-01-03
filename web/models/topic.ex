defmodule Discuss.Topic do
  use Discuss.Web, :model

  # Maps title to topics database table in postgres
  schema "topics" do
    field :title, :string
  end

  # params defaults nil to empty map using \\ %{}
  def changeset(struct, params \\ %{}) do
    struct
    # Creates a changeset object
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end
