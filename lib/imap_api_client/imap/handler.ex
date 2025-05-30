defmodule ImapApiClient.Imap.Handler do
  @moduledoc """
  Gestionnaire pour traiter les emails reçus et gérer les pièces jointes.
  Désormais, il délègue le traitement au module ImapApiClient.Github.MailFilter.
  """

  require Logger
  # Alias le module MailFilter car nous allons l'appeler
  alias ImapApiClient.Github.MailFilter

  @doc """
  Traite un message email reçu en le déléguant au MailFilter pour classification
  et potentielle création de ticket GitHub.

  Affiche un log initial et log le résultat du traitement par le MailFilter.
  """
  # In handler.ex
def handle_message(message) do
  default_classification = %{
    category: "support_client",
    priority: "medium",
    confidence: 0.5,
    labels: []
  }

  case MailFilter.process_email(message, default_classification) do
    {:ok, :issue_created, issue_number} ->
      {:ok, :issue_created, issue_number}

    {:error, reason} ->
      {:error, :processing_failed, reason}

    other ->
      Logger.warning("MailFilter returned unexpected result: #{inspect(other)}")
      other
  end
end

end
