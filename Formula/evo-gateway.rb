class EvoGateway < Formula
  desc "Multi-provider LLM proxy for the Evo self-evolution agent system"
  homepage "https://github.com/ai-evo-agents/evo-gateway"
  version "0.5.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ai-evo-agents/evo-gateway/releases/download/v#{version}/evo-gateway-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "8b570b380e4a49002e4ece07b2d78b7e28195609ec1baf5133a1e5ef8d3527d6"
    else
      url "https://github.com/ai-evo-agents/evo-gateway/releases/download/v#{version}/evo-gateway-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "ec2cc149c91e726985a63123818115031122db8f6ea6bb90731404959a25784f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ai-evo-agents/evo-gateway/releases/download/v#{version}/evo-gateway-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fc44e3f6a1f09a25abf63d3db27312522b09234d18e3775ef175559bac7416c7"
    else
      url "https://github.com/ai-evo-agents/evo-gateway/releases/download/v#{version}/evo-gateway-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b79b26a5a959ea1bde50b9853b4292574ff86180f8ed035cb6d9f76e3bac0cad"
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
        OPENAI_API_KEY      OpenAI API key
        ANTHROPIC_API_KEY   Anthropic API key
        RUST_LOG            Log level (default: info)
        EVO_OTLP_ENDPOINT   OTLP endpoint for distributed tracing (optional)
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evo-gateway --version")
  end
end
