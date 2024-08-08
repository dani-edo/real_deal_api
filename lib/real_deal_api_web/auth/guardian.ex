defmodule RealDealApiWeb.Auth.Guardian do
  use Guardian, otp_app: :real_deal_api
  alias RealDealApi.Accounts

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :no_id_provided}
  end

  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_account!(id) do
      nil -> {:error, :not_found}
      resource -> {:ok, resource}
    end
  end

  def resource_from_claims(_claims) do
    {:error, :no_id_provided}
  end

  def authenticate(email, password) do
    case Accounts.get_account_by_email(email) do
      nil -> {:error, :unauthorized} # if the value is nil, it will return :unauthorized
      account -> # if there is a value (account), we need to validate the password
        case validate_password(password, account.hash_password) do
          true -> create_token(account)
          false -> {:error, :unauthorized}
        end
    end
  end

  def validate_password(password, hash_password) do
    Bcrypt.verify_pass(password, hash_password)
  end

  def create_token(account) do
    {:ok, token, _claims} = encode_and_sign(account) # encode_and_sign: https://hexdocs.pm/guardian/Guardian.html#module-encode_and_sign-resource-claims-opts
    {:ok, account, token} # we will return the account and the token
  end
end
