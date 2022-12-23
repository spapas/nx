import Config

System.put_env("PYTORCH_ENABLE_MPS_FALLBACK", "1")

config :torchx,
  add_backend_on_inspect: config_env() != :test,
  check_shape_and_type: config_env() == :test
