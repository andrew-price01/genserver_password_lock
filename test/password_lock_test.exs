defmodule PasswordLockTest do
  use ExUnit.Case
  doctest PasswordLock

  setup do
    {:ok, server_pid} = PasswordLock.start_link("pw123")
    {:ok, server: server_pid}
  end

  test "unlock success test", %{server: pid} do
    assert :ok == PasswordLock.unlock(pid, "pw123")
  end

  test "unlock failure test", %{server: pid} do
    assert {:error, "wrong password"} == PasswordLock.unlock(pid, "123")
  end

  test "reset success test", %{server: pid} do
    assert :ok == PasswordLock.reset(pid, {"pw123", "pw"})
  end

  test "reset failure test", %{server: pid} do
    assert {:error, "wrong password"} == PasswordLock.reset(pid, {"pw", "pw123"})
  end
end
