Application.put_env(:nx, :default_backend, Torchx.Backend)
ExUnit.start(exclude: [:skip_mps])
