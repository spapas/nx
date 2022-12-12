defmodule Torchx.NxDoctestTest do
  @moduledoc """
  Import Nx' doctest and run them on the Torchx backend.

  Many tests are excluded for the reasons below, coverage
  for the excluded tests can be found on Torchx.NxTest.
  """

  use ExUnit.Case, async: true

  setup do
    Nx.default_backend(Torchx.Backend)
    :ok
  end

  @rounding_error_doctests [
    atanh: 1,
    ceil: 1,
    cos: 1,
    cosh: 1,
    erfc: 1,
    erf_inv: 1,
    round: 1,
    sigmoid: 1,
    fft: 2,
    ifft: 2
  ]

  case :os.type() do
    {:win32, _} -> @os_rounding_error_doctests [expm1: 1, erf: 1]
    _ -> @os_rounding_error_doctests []
  end

  @unrelated_doctests [
    default_backend: 1
  ]

  @inherently_unsupported_doctests [
    # as_type - the rules change per type
    as_type: 2,
    # no API available - bit based
    count_leading_zeros: 1,
    population_count: 1,
    # no API available - function based
    map: 3,
    window_reduce: 5,
    reduce: 4
  ]

  @mps_incompatible if(Torchx.default_device() == :mps,
                      do: [
                        conjugate: 1,
                        real: 1,
                        imag: 1,
                        complex: 2,
                        weighted_mean: 3,
                        standard_deviation: 2,
                        window_scatter_max: 5,
                        window_scatter_min: 5,
                        window_sum: 3,
                        window_product: 3,
                        window_max: 3,
                        window_mean: 3,
                        window_min: 3,
                        quotient: 2,
                        remainder: 2,
                        mode: 2,
                        log: 1,
                        log1p: 1,
                        power: 2,
                        atan2: 2,
                        conv: 3,
                        is_nan: 1,
                        is_infinity: 1,
                        phase: 1,
                        abs: 1,
                        random_normal: 4,
                        sinh: 1,
                        acosh: 1,
                        cosh: 1,
                        asinh: 1,
                        tensor: 2,
                        sin: 1,
                        cos: 1,
                        negate: 1,
                        asin: 1,
                        exp: 1,
                        atan: 1,
                        acos: 1
                      ],
                      else: []
                    )

  doctest Nx,
    except:
      @rounding_error_doctests
      |> Kernel.++(@os_rounding_error_doctests)
      |> Kernel.++(@inherently_unsupported_doctests)
      |> Kernel.++(@unrelated_doctests)
      |> Kernel.++(@mps_incompatible)
      |> Kernel.++([:moduledoc])
end
