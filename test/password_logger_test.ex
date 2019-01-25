defmodule PasswordLoggerTest do
    use ExUnit.Case

    setup do
      {:ok, logfile} = PasswordLogger.start_link()
      {:ok, file: logfile}
    end
end