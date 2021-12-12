defmodule SearchParserTest do
  use ExUnit.Case
  alias SearchParser.Language
  doctest SearchParser

  describe "parser" do
    test "it should parse a string" do
      [:ok, parsed | _rest] =
        Language.parse("hello world")
        |> Tuple.to_list()

      assert parsed == ["hello", "world"]
    end

    test "it should group quoted strings" do
      [:ok, parsed | _rest] =
        Language.parse("\"hello world\"")
        |> Tuple.to_list()

      assert parsed == [{:quoted, "hello world"}]
    end

    test "it should handle user filters" do
      [:ok, parsed | _rest] =
        Language.parse("user:a")
        |> Tuple.to_list()

      assert parsed == [{:filter, ["user", "a"]}]
    end

    test "it should handle instance filters" do
      [:ok, parsed | _rest] =
        Language.parse("instance:a.com")
        |> Tuple.to_list()

      assert parsed == [{:filter, ["instance", "a.com"]}]
    end

    test "it should handle hashtag filters" do
      [:ok, parsed | _rest] =
        Language.parse("hashtag:#a")
        |> Tuple.to_list()

      assert parsed == [{:filter, ["hashtag", "a"]}]
    end

    test "it should handle two filters" do
      [:ok, parsed | _rest] =
        Language.parse("hashtag:#a instance:b.com")
        |> Tuple.to_list()

      assert parsed == [
               {:filter, ["hashtag", "a"]},
               {:filter, ["instance", "b.com"]}
             ]
    end

    test "it should handle an overly complex filter" do
      [:ok, parsed | _rest] =
        Language.parse("hashtag:#a secret instance:b.com user:c d \"e\"")
        |> Tuple.to_list()

      assert parsed == [
               {:filter, ["hashtag", "a"]},
               "secret",
               {:filter, ["instance", "b.com"]},
               {:filter, ["user", "c"]},
               "d",
               {:quoted, "e"}
             ]
    end
  end
end
