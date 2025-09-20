import envoy
import gleam/http/request
import gleam/http/response.{type Response}
import gleam/httpc.{type HttpError}
import gleam/io
import gleam/result
import gleam/string

pub opaque type Config {
  Config(api_key: String)
}

pub fn build_config() {
  envoy.get("API_KEY")
  |> result.unwrap("lel")
  |> Config
}

pub fn main() {
  let config = build_config()
  polling(config)
}

pub fn get_response_body(result: Result(Response(String), HttpError)) -> String {
  case result {
    Ok(response) -> response.body
    Error(_) -> "Error"
  }
}

pub fn polling(config: Config) {
  let url = "https://api.telegram.org/bot{token}/getUpdates"

  let final_url = string.replace(url, "{token}", config.api_key)

  let assert Ok(req) = request.to(final_url)

  req
  |> httpc.send
  |> get_response_body
  |> io.println
}
