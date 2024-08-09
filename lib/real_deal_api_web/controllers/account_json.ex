defmodule RealDealApiWeb.AccountJSON do
  alias RealDealApi.Accounts.Account

  @doc """
  Renders a list of accounts.
  """
  def index(%{accounts: accounts}) do
    %{data: for(account <- accounts, do: data(account, nil))}
  end

  @doc """
  Renders a single account.
  """
  def show(%{account: account, token: token}) do
    %{data: data(account, token)}
  end

  defp data(%Account{} = account, token) do
    %{
      id: account.id,
      email: account.email,
      token: token
    }
  end
end
