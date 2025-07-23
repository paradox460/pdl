defmodule Pdl do
  @doc """
    Adds value to `key` in the process dictionary.

    Returns error if `key` already exists in the process dictionary and is not a list.
  """
  @spec add(key :: term(), value :: term()) :: :ok | {:error, String.t()}
  def add(key, value) do
    store = Process.get(key, [])

    if !is_list(store) do
      {:error, "Key `#{inspect(key)}` is not a list in process dictionary"}
    else
      Process.put(key, [value | store])
      :ok
    end
  end

  @doc """
    Adds value to `key` in the process dictionary.

    Raises if `key` already exists in the process dictionary and is not a list.
  """
  @spec add!(key :: term(), value :: term()) :: :ok
  def add!(key, value) do
    case add(key, value) do
      :ok -> :ok
      {:error, reason} -> raise ArgumentError, reason
    end
  end

  @doc """
    Adds multiple values to `key` in the process dictionary.

    Returns error if `key` already exists in the process dictionary and is not a list.
  """
  @spec add_many(term(), [term()]) :: :ok | {:error, String.t()}
  def add_many(key, values) do
    store = Process.get(key, [])

    if !is_list(store) do
      {:error, "Key `#{inspect(key)}` is not a list in process dictionary"}
    else
      values
      |> Enum.reverse()
      |> then(&[&1 | store])
      |> List.flatten()
      |> then(&Process.put(key, &1))

      :ok
    end
  end

  @doc """
    Adds multiple values to `key` in the process dictionary.

    Raises if `key` already exists in the process dictionary and is not a list.
  """
  @spec add_many!(term(), [term()]) :: :ok
  def add_many!(key, values) do
    case add_many(key, values) do
      :ok -> :ok
      {:error, reason} -> raise ArgumentError, reason
    end
  end

  @doc """
    Fetches the value stored in `key` in the process dictionary.

    Errors if the value is not a list
  """
  @spec get(term()) :: [term()] | {:error, String.t()}
  def get(key) do
    values = Process.get(key, [])

    if !is_list(values) do
      {:error, "Key `#{inspect(key)}` is not a list in process dictionary"}
    else
      values
      |> Enum.reverse()
    end
  end

  @doc """
    Fetches the value stored in `key` in the process dictionary.

    Raises if the value is not a list
  """
  @spec get!(term()) :: [term()]
  def get!(key) do
    case get(key) do
      {:error, reason} -> raise ArgumentError, reason
      values -> values
    end
  end

  @doc """
    Runs the given `fun` over every value stored in `key` in the process dictionary, receiving each value as an argument to fun

    Returns a list of the results of `fun`.
  """
  @spec run(term(), (term() -> term())) :: [term()]
  def run(key, fun) do
    Process.get(key, [])
    |> Enum.reverse()
    |> Enum.map(fun)
  end

  @doc """
    Runs the given `fun` over every unique value stored in `key` in the process dictionary, receiving each value as an argument to fun

    Returns a list of the results of `fun`.
  """
  @spec run_unique(term(), (term() -> term())) :: [term()]
  def run_unique(key, fun) do
    Process.get(key, [])
    |> Enum.uniq()
    |> Enum.reverse()
    |> Enum.map(fun)
  end

  @doc """
    Runs the given `fun` over the _entire_ value stored in the process dictionary `key`.

    Returns the result of `fun`.
  """
  @spec run_all(term(), ([term()] -> term())) :: term()
  def run_all(key, fun) do
    Process.get(key, [])
    |> Enum.reverse()
    |> then(&fun.(&1))
  end
end
