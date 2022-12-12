Application.put_env(:nx, :default_backend, Torchx.Backend)

skip_mps = Torchx.default_device() == :mps
Application.put_env(:torchx, :skip_mps, true)

ExUnit.start(
  exclude: [
    skip_mps: skip_mps,
    skip_mps_indexed: skip_mps,
    skip_mps_all_close: skip_mps,
    skip_mps_dot_floating: skip_mps,
    skip_mps_quotient_s64: skip_mps
  ]
)
