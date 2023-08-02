defmodule ExGuard.Notifier.TMuxTest do
  use ExUnit.Case

  alias ExGuard.Notifier.TMux

  test "prepare TerminalNotifier command" do
    command = TMux.prepare_cmd(title: "unit test", message: "boo", status: :ok)

    assert command ==
             ~s(tmux display-message '#[fill=green bg=green]unit test - boo'; tmux set -g pane-active-border fg=green)

    command = TMux.prepare_cmd(title: "unit test", message: "boo", status: :error)

    assert command ==
             ~s(tmux display-message '#[fill=red bg=red]unit test - boo'; tmux set -g pane-active-border fg=red)

    command = TMux.prepare_cmd(title: "unit test", message: "boo", status: :pending)

    assert command ==
             ~s(tmux display-message '#[fill=yellow bg=yellow]unit test - boo'; tmux set -g pane-active-border fg=yellow)
  end

  test "tmux shouln't be available out of tmux session" do
    tmux_val = System.get_env("TMUX")
    if tmux_val, do: System.delete_env("TMUX")
    assert TMux.available?() == false
    if tmux_val, do: System.put_env("TMUX", tmux_val)
  end

  test "tmux should be available  tmux session" do
    tmux_val = System.get_env("TMUX")
    if tmux_val, do: System.delete_env("TMUX")
    System.put_env("TMUX", "VAL")
    assert TMux.available?() == true
    if tmux_val, do: System.put_env("TMUX", tmux_val)
  end
end
