class EvoGateway < Formula
  desc "Multi-provider LLM proxy for the Evo self-evolution agent system"
  homepage "https://github.com/ai-evo-agents/evo-gateway"
  version "0.7.3"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ai-evo-agents/evo-gateway/releases/download/v#{version}/evo-gateway-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "ef20d907ae4554faf0a405bd9512d9e6d8350ee8a363ec71d33fc4c7725a8175"
    else
      url "https://github.com/ai-evo-agents/evo-gateway/releases/download/v#{version}/evo-gateway-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "97fa6c8139b9137b1833d192a20ff150bda2fffa5e9119342ca87626da606619"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ai-evo-agents/evo-gateway/releases/download/v#{version}/evo-gateway-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f7f195b6d6430130bbef6177828b58a47aeb851d969b65b52552ec063b478776"
    else
      url "https://github.com/ai-evo-agents/evo-gateway/releases/download/v#{version}/evo-gateway-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "da75103010740395384dfbb149d8a4545866cf95b07bc3983ca9fbcc4d0544a9"
    end
  end

  def install
    bin.install "evo-gateway"
  end

  def post_install
    (var/"evo-agents/logs").mkpath
  end

  service do
    run [opt_bin/"evo-gateway"]
    keep_alive true
    log_path var/"evo-agents/logs/evo-gateway.log"
    error_log_path var/"evo-agents/logs/evo-gateway.error.log"
    environment_variables(
      RUST_LOG: "info",
    )
    working_dir var/"evo-agents/data"
  end

  def caveats
    <<~EOS
      evo-gateway proxies LLM API requests to multiple providers.

      To run as a background service:
        brew services start evo-gateway

      Or run manually:
        evo-gateway

      Configure providers in gateway.json.

      Environment variables:
        OPENAI_API_KEY           OpenAI API key
        ANTHROPIC_API_KEY        Anthropic API key
        GEMINI_API_KEY           Google Gemini API key
        COPILOT_GITHUB_TOKEN     GitHub PAT for Copilot (or GH_TOKEN)
        RUST_LOG                 Log level (default: info)
        EVO_OTLP_ENDPOINT        OTLP endpoint for distributed tracing (optional)
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evo-gateway --version")
  end
end
