class EvoGateway < Formula
  desc "Multi-provider LLM proxy for the Evo self-evolution agent system"
  homepage "https://github.com/ai-evo-agents/evo-gateway"
  version "0.6.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ai-evo-agents/evo-gateway/releases/download/v#{version}/evo-gateway-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "6e8671265d3d33eb6abab67fb64ff5d004e3c61a000c7b767d4039f600afdb78"
    else
      url "https://github.com/ai-evo-agents/evo-gateway/releases/download/v#{version}/evo-gateway-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "410e6f14fdac75aa69dca9fd51ed1caddabeb51524e141e7bd386216efdbd652"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ai-evo-agents/evo-gateway/releases/download/v#{version}/evo-gateway-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "112b765073d08a22a849ddcd33cb06c40c8a82b239f72a6afbe37bb2ae4e15fa"
    else
      url "https://github.com/ai-evo-agents/evo-gateway/releases/download/v#{version}/evo-gateway-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "255f8d52cf3fb91ade5004387597120352f419e9a49e8dd9d1ac221855bc77a0"
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
