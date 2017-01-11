defmodule Discuss.Topic do
  use Discuss.Web, :model

  # Maps title to topics database table in postgres
  schema "topics" do
    field :title, :string
    belongs_to :user, Discuss.User
    has_many :comments, Discuss.Comment
  end

  # params defaults nil to empty map using \\ %{}
  def changeset(struct, params \\ %{}) do
    struct
    # Creates a changeset object
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end
