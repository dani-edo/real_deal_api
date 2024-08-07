# databaseschema
defmodule RealDealApi.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :email, :string
    field :hash_password, :string
    has_one :user, RealDealApi.Users.User # user schema

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:email, :hash_password])
    |> validate_required([:email, :hash_password])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces") # email format validation
    |> validate_length(:email, max: 160)
    |> unique_constraint(:email) # unique email validation (before validated by database)
    |> put_password_hash()
  end

  # handhle hashing password
  def put_password_hash(%Ecto.Changeset{valid?: true, changes: %{hash_password: hash_password}} = changeset) do
    change(changeset, hash_password: Bcrypt.hash_pwd_salt(hash_password))
  end

  # if change set is not valid, so will return changeset
  def put_password_hash(changeset), do: changeset
end
