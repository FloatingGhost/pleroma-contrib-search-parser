defmodule SearchParser.Language do
  import NimbleParsec

  term = utf8_string([not: ?\s], min: 1)

  quoted_term =
    ascii_char([?"])
    |> replace('')
    |> repeat_while(
      choice([
        ~S(\") |> string() |> replace('"'),
        utf8_char([])
      ]),
      {:not_quote, []}
    )
    |> ignore(ascii_char([?"]))
    |> reduce({List, :to_string, []})
    |> unwrap_and_tag(:quoted)

  hashtag =
    ascii_char([?#])
    |> replace('')
    |> repeat(utf8_char(not: ?\s))
    |> reduce({List, :to_string, []})

  search_filter =
    choice([string("user"), string("instance")])
    |> ignore(string(":"))
    |> choice([quoted_term, term])
    |> tag(:filter)

  hashtag_filter =
    string("hashtag")
    |> ignore(string(":"))
    |> choice([hashtag, term])
    |> tag(:filter)

  defcombinatorp(
    :search_term,
    choice([search_filter, hashtag_filter, quoted_term, term])
  )

  defcombinatorp(
    :search,
    empty()
    |> choice([
      parsec(:search_term)
      |> ignore(string(" "))
      |> concat(parsec(:search)),
      parsec(:search_term)
    ])
  )

  defparsec(:parse, parsec(:search))

  defp not_quote(<<?", _::binary>>, context, _, _), do: {:halt, context}
  defp not_quote(_, context, _, _), do: {:cont, context}
end
