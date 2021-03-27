defmodule JavaCodeQuality do
  defstruct id: "", file: "", loc: 0, number_of_classes: 0, number_of_methods: 0

  def main do
    keywords = [
      "DispatchQueue.txt",
      "FileLoader.txt",
      "FileLog.txt",
      "FileUploadOperation.txt",
      "UserConfig.txt",
      "Utilities.txt"
    ]

    items = Enum.to_list(1..27)

    Enum.each(items, fn index ->
      Enum.each(keywords, fn keyword ->
        url =
          "https://raw.githubusercontent.com/danilomartinelli/java_code_quality/main/Dataset/#{
            index
          }/#{keyword}"

        text =
          url
          |> get_text
          |> refactor_text

        IO.inspect(%JavaCodeQuality{
          id: index,
          file: keyword,
          loc: count_lines(text),
          number_of_classes: count_classes(text),
          number_of_methods: count_methods(text)
        })
      end)
    end)
  end

  defp get_text(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found :(")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end

  defp refactor_text(text) do
    text
    |> String.replace(~r/(\/\*(.|[\r\n])*?\*\/)|(\/\/.*)/, "")
    |> String.replace(~r/(\n){2,}/, "\n")
    |> String.trim()
  end

  defp count_lines(text) do
    case text do
      "" -> 0
      str -> length(String.split(str, "\n")) - 1
    end
  end

  defp count_classes(text) do
    case text do
      "" -> 0
      str -> length(String.split(str, ~r/[\w\d][\w\d\s\n]*[\s\n]+class[\s\n]+[\w\d\s\n\,]*{/)) - 1
    end
  end

  defp count_methods(text) do
    case text do
      "" ->
        0

      str ->
        length(
          String.split(
            str,
            ~r/(public|protected|private|static|\s) +[\w\<\>\[\]]+\s+(\w+) *\([^\)]*\) *(\{?|[^;])/
          )
        ) - 1
    end
  end
end
