defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    target = Enum.random(1..10)

    {:ok, assign(socket, number: target, score: 0, message: "Make a guess:", time: "", new_game: false, correct: false)}
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    guess = String.to_integer(guess)

    {message, score, new_game, correct} =
      if guess == socket.assigns.number do
        {
          "Correct! The number was #{socket.assigns.number}.",
          socket.assigns.score + 1,
          true,
          true
        }
      else
        {
          "Your guess: #{guess}. Wrong. Guess again.",
          socket.assigns.score - 1,
          false,
          false
        }
      end

    number =
      if new_game do
        Enum.random(1..10)
      else
        socket.assigns.number
      end

    time = DateTime.utc_now |> to_string
    {
      :noreply,
      assign(
        socket,
        message: message,
        score: score,
        number: number,
        time: "It's: #{time}",
        new_game: new_game,
        correct: correct
      )
    }
  end

  def handle_event("restart", _params, socket) do
    new_number = Enum.random(1..10)

    score =
      if socket.assigns.score < 0 do
        0
      else
        socket.assigns.score
      end

    {:noreply,
      assign(socket,
        number: new_number,
        score: score,
        message: "New game started! Make a guess:",
        time: "",
        new_game: false
      )}
  end


  def render(assigns) do
    ~H"""
      <h1 class="mb-4 text-4xl font-extrabold">Your score: {@score}</h1>


      <%= if @correct do %>
          <h2 class=" bg-green-600 mt-4 p-4 rounded shadow text-black font-semibold text-lg ">
            {@message}
            {@time}
          </h2>
        <% else %>
           <h2 class=" bg-red-500 mt-4 p-4 rounded shadow text-black font-semibold text-lg ">
              {@message}
              {@time}
          </h2>
      <% end %>

      <br />
      <h2>
        <%= for n <- 1..10 do %>
          <.link href="#"
            class="bg-blue-500 hover:bg-blue-700
             text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
            phx-click="guess"
            phx-value-number={n}
          >
          {n}
          </.link>
        <% end %>

        <%= if @new_game do %>
          <button
            phx-click="restart"
            class="bg-green-600 hover:bg-green-700 text-white font-bold py-2 px-4 rounded shadow-md mt-4"
          >RESTART</button>
        <% end %>

    </h2>
    """
  end

end
