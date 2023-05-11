defmodule Genomeur do
  @moduledoc """
  Genomeur view using Scenic
  """

  def start(_type, _args) do
    # provides deeper stacktraces
    :erlang.system_flag(:backtrace_depth, 20)
    # load the viewport config from config
    main_viewport_config = Application.get_env(:genomeur, :viewport)

    # start the app with the viewport
    children = [
      {Scenic, [main_viewport_config]},
      Genomeur.PubSub.Supervisor
    ]

    # this is where we can set names for vp process, size, default scene
    # AND Start drivers! so if it automatically starts listening for a tournament, that'd be here
    # but we don't want that, we want that after a button on one of the pages
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
