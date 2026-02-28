class EvoGateway < Formula
  desc "Multi-provider LLM proxy for the Evo self-evolution agent system"
  homepage "https://github.com/ai-evo-agents/evo-gateway"
  version "0.4.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ai-evo-agents/evo-gateway/releases/download/v#{version}/evo-gateway-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "e50dc022940cd5d8c22bf1c513e4cde888c3c9bb8b18756dd8789e81c4a077aa"
    else
      url "https://github.com/ai-evo-agents/evo-gateway/releases/download/v#{version}/evo-gateway-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "6e75958c3e560e76c32ba4aa035865b3c4bbf63018b7cbba97fe8269844b3900"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ai-evo-agents/evo-gateway/releases/download/v#{version}/evo-gateway-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fbd66a8df997db1a1a55eb52bf7a79bd699630b893747670d2c32808a7d6a0e8"
    else
      url "https://github.com/ai-evo-agents/evo-gateway/releases/download/v#{version}/evo-gateway-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "37148076ba49112fd342cf3c970707c461d5842b116d8c68ca265192a3220127"
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
