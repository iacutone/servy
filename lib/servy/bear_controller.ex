defmodule Servy.BearController do
  alias Servy.WildThings
  alias Servy.Bear

  @templates_path Path.expand("../../templates", __DIR__)

  # defp bear_item(bear) do
  #   "<li>#{bear.name} - #{bear.type}</li"
  # end

  defp render(conv, template, bindings \\ []) do
    content = 
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(bindings)

    %{ conv | status: 200, resp_body: content }
  end

  def index(conv) do
    # items = 
    #   WildThings.list_bears()
    #   |> Enum.filter(&Bear.is_grizzly?(&1))
    #   |> Enum.sort(&Bear.order_asc_by_name(&1, &2))
    #   |> Enum.map(fn(b) -> bear_item(b) end)
    #   |> Enum.join

    # %{ conv | status: 200, resp_body: "<ul>#{items}</ul>" }

    bears = 
      WildThings.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2)

    render(conv, "index.eex", bears: bears)
  end

  def show(conv, %{"id" => id}) do
    bear = WildThings.get_bear(id)

    render(conv, "show.eex", bear: bear)
  end

  def create(conv, %{"name" => name, "type" => type}) do
    %{ conv | status: 201, 
      resp_body: "Created a #{type} bear named #{name}" 
    }
  end
end
