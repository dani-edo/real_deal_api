defmodule RealDealApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :full_name, :string
      add :gender, :string
      add :biography, :text
      add :account_id, references(:accounts, on_delete: :delete_all, type: :binary_id) # delete_all: when account is deleted, it will delete all users related

      timestamps(type: :utc_datetime)
    end

    create index(:users, [:account_id, :full_name]) # create index so it will be faster to search
  end
end
