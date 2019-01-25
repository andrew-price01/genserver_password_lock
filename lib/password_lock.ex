defmodule PasswordLock do
  use GenServer

  # -------------#
  # Client - API #
  # -------------#

  def start_link(password) do
    GenServer.start_link(__MODULE__, password, [])
  end

  def unlock(server_pid, password) do
    GenServer.call(server_pid, {:unlock, password})
  end

  def reset(server_pid, {old_password, new_password}) do
    GenServer.call(server_pid, {:reset, {old_password, new_password}})
  end

  # -------------#
  # Server - API #
  # -------------#

  def init(password) do
    {:ok, [password]}
  end

  def handle_call({:unlock, password}, _from, passwords) do
    if password in passwords do
      {:reply, :ok, passwords}
    else 
      write_to_log password
      {:reply, {:error, "incorrect password"}, passwords}
    end
  end

  def handle_call({:reset, {old_password, new_password}}, _from, passwords) do
    if old_password in passwords do
      state = List.delete(passwords, old_password)
      {:reply, :ok, [new_password | state]}
    else
      write_to_log new_password
      {:reply, {:error, "incorrect password"}, passwords}
    end
  end

  defp write_to_log text do
    {:ok, pid} = PasswordLogger.start_link()
    PasswordLogger.log_incorrect pid, "incorrect password: #{text}"
  end
end
