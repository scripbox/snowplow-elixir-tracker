defmodule SnowplowTracker.SubjectTest do
  use ExUnit.Case

  alias SnowplowTracker.Subject

  describe "set_user_id/2" do
    test "sets the user_id in the subject object" do
      expected_response = %{
        "uid" => "UCANTSEEME"
      }

      response =
        %Subject{}
        |> Subject.set_user_id("UCANTSEEME")
        |> Subject.get()

      assert match?(^expected_response, response)
    end
  end

  describe "set_screen_resolution/3" do
    test "sets the screen_resolution in the subject object" do
      expected_response = %{
        "res" => "800x600"
      }

      response =
        %Subject{}
        |> Subject.set_screen_resolution(800, 600)
        |> Subject.get()

      assert match?(^expected_response, response)
    end
  end

  describe "set_viewport/3" do
    test "sets the viewport in the subject object" do
      expected_response = %{
        "vp" => "800x600"
      }

      response =
        %Subject{}
        |> Subject.set_viewport(800, 600)
        |> Subject.get()

      assert match?(^expected_response, response)
    end
  end

  describe "set_color_depth/2" do
    test "sets the color_depth in the subject object" do
      expected_response = %{
        "cd" => 3
      }

      response =
        %Subject{}
        |> Subject.set_color_depth(3)
        |> Subject.get()

      assert match?(^expected_response, response)
    end
  end

  describe "set_timezone/2" do
    test "sets the timezone in the subject object" do
      expected_response = %{
        "tz" => "Asia/Kolkata"
      }

      response =
        %Subject{}
        |> Subject.set_timezone("Asia/Kolkata")
        |> Subject.get()

      assert match?(^expected_response, response)
    end
  end

  describe "set_platform/2" do
    test "sets the language in the subject object" do
      expected_response = %{
        "p" => "pc"
      }

      response =
        %Subject{}
        |> Subject.set_platform("pc")
        |> Subject.get()

      assert match?(^expected_response, response)
    end
  end

  describe "set_language/2" do
    test "sets the language in the subject object" do
      expected_response = %{
        "lang" => "EN"
      }

      response =
        %Subject{}
        |> Subject.set_language("EN")
        |> Subject.get()

      assert match?(^expected_response, response)
    end
  end

  describe "set_ip_address/2" do
    test "sets the language in the subject object" do
      expected_response = %{
        "ip" => "192.168.0.1"
      }

      response =
        %Subject{}
        |> Subject.set_ip_address("192.168.0.1")
        |> Subject.get()

      assert match?(^expected_response, response)
    end
  end

  describe "set_user_agent/2" do
    test "sets the language in the subject object" do
      expected_response = %{
        "ua" => "firefox"
      }

      response =
        %Subject{}
        |> Subject.set_user_agent("firefox")
        |> Subject.get()

      assert match?(^expected_response, response)
    end
  end

  describe "set_domain_user_id/2" do
    test "sets the language in the subject object" do
      expected_response = %{
        "duid" => "domain_user_007"
      }

      response =
        %Subject{}
        |> Subject.set_domain_user_id("domain_user_007")
        |> Subject.get()

      assert match?(^expected_response, response)
    end
  end

  describe "set_network_user_id/2" do
    test "sets the language in the subject object" do
      expected_response = %{
        "tnuid" => "network_user_007"
      }

      response =
        %Subject{}
        |> Subject.set_network_user_id("network_user_007")
        |> Subject.get()

      assert match?(^expected_response, response)
    end
  end
end
