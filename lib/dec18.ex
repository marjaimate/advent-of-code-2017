defmodule Dec18 do
  @instructions [
   "set i 31",
   "set a 1",
   "mul p 17",
   "jgz p p",
   "mul a 2",
   "add i -1",
   "jgz i -2",
   "add a -1",
   "set i 127",
   "set p 316",
   "mul p 8505",
   "mod p a",
   "mul p 129749",
   "add p 12345",
   "mod p a",
   "set b p",
   "mod b 10000",
   "snd b",
   "add i -1",
   "jgz i -9",
   "jgz a 3",
   "rcv b",
   "jgz b -1",
   "set f 0",
   "set i 126",
   "rcv a",
   "rcv b",
   "set p a",
   "mul p -1",
   "add p b",
   "jgz p 4",
   "snd a",
   "set a b",
   "jgz 1 3",
   "snd b",
   "set f 1",
   "add i -1",
   "jgz i -11",
   "snd a",
   "jgz f -16",
   "jgz a -19"
  ]

  def solve do
    # Go through the instructions, step by step until we got to a RCV instruction
    state = step(%{position: 0})
    List.first(state[:send_queue])
  end

  def solve2 do
    # Use Agent.start and its message queues instead
    p0 = %{"pid" => 0, "p" => 0, position: 0, send_counter: 0, halt: false, waiting: false, send_queue: []}
    p1 = %{"pid" => 1, "p" => 1, position: 0, send_counter: 0, halt: false, waiting: false, send_queue: []}

    step2({p0, p1})
  end

  def finished?({%{halt: true} = p0, %{halt: true} = p1}), do: {:finished, p0, p1}
  def finished?({%{waiting: true} = p0, %{halt: true} = p1}), do: {:finished, p0, p1}
  def finished?({%{halt: true} = p0, %{waiting: true} = p1}), do: {:finished, p0, p1}
  def finished?({%{waiting: true, send_queue: []} = p0, %{waiting: true} = p1}), do: {:finished, p0, p1}
  def finished?({p0, p1}), do: {p0, p1}

  def step2({:finished, p0, p1}), do: {p0, p1}
  def step2({p0, p1}) do
    # step through the next parts, until we rech the read queue part
    # Try to send through the messages p0 -> p1
    {p0_state, p1_state} ={step(p0), p1}
                          |> try_send

    # Try to send through the messages p1 -> p0
    {p1_state2, p0_state2} = {step(p1_state), p0_state}
                             |> try_send

    {p0_state2, p1_state2}
    |> finished?
    |> step2
  end

  # Need to check the send queue of the other programme, and if we are in a waiting state
  def try_send {%{send_queue: [msg | other_msgs], halt: false} = from, %{waiting: true, halt: false, rcv_in: target_reg} = to} do
    # Pop the message to the process and update the queue
    from_state = from
                   |> Map.put(:send_queue, other_msgs) # reduce the queue
                   |> Map.update(:send_counter, 1, &(&1 + 1)) # update send counter

    to_state = Map.put(to, :waiting, false) # unlock the waiting state
               |> Map.put(:rcv_in, nil)
               |> Map.put(target_reg, msg) # put the msg to the register

    log "SENT #{from_state["pid"]} @ #{from_state.position} [#{msg}] => #{to_state["pid"]} @ #{to_state.position} target reg: #{target_reg} || remaining Q: #{inspect other_msgs}", "out.log"

    { from_state, to_state }
  end
  def try_send({from, to}), do: {from, to}

  def log(msg), do: IO.puts(msg)
  def log(msg, fname) do
    with {:ok, f} <- File.open(fname, [:append]) do
      IO.binwrite(f, msg <> "\n")
      File.close(f)
    end
  end

  # Step through the intstruction till we hit a RCV where we wait
  def step(%{waiting: true} = state), do: state
  def step(%{halt: true} = state), do: state
  def step(state) do
    case valid_position?(@instructions, state[:position]) do
      :halt -> Map.put(state, :halt, true)
      index ->
        next_state = @instructions
                      |> Enum.at(index)
                      |> state_change(state)
        case next_state do
          {:jump, steps} -> step(jump(state, steps)) # Make a jump
          state2 -> step(jump(state2, 1))
        end
    end
  end

  def valid_position?(instructions, position) when length(instructions) > position, do: position
  def valid_position?(_instructions, position) when 0 > position, do: position
  def valid_position?(_instructions, _position), do: :halt

  # Transcribe the state changes
  def state_change <<"snd ", reg::binary-size(1)>>, state do
    Map.update(state, :send_queue, [state[reg]], &([state[reg] | &1]))
  end

  def state_change <<"set ", reg::binary-size(1), " ", value::binary>>, state do
    Map.put(state, reg, get_reg_or_value(value, state))
  end

  def state_change <<"add ", reg::binary-size(1), " ", value::binary>>, state do
    Map.update(state, reg, get_reg_or_value(value, state), &(&1 + get_reg_or_value(value, state)))
  end

  def state_change <<"mul ", reg::binary-size(1), " ", value::binary>>, state do
    Map.update(state, reg, 0, &(&1 * get_reg_or_value(value, state)))
  end

  def state_change <<"mod ", reg::binary-size(1), " ", value::binary>>, state do
    Map.update(state, reg, 0, &(rem(&1, get_reg_or_value(value, state))))
  end

  def state_change <<"rcv ", reg::binary-size(1)>>, state do
    case state[reg] do
      0 -> state
      _ ->
        state
        |> Map.put(:waiting, true)
        |> Map.put(:rcv_in, reg)
    end
  end

  def state_change <<"jgz ", reg::binary-size(1), " ", value::binary>>, state do
    case state[reg] > 0 do
      false -> state
      true -> {:jump, get_reg_or_value(value, state)}
    end
  end

  # Make a jump
  def jump(state, steps) do
    Map.update!(state, :position, &(&1 + steps))
  end

  # Look up value, or return with integer value provided
  def get_reg_or_value(str, state) do
    case Integer.parse(str) do
      :error -> state[str]
      {value, _} -> value
    end
  end
end
