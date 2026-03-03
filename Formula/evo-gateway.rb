class EvoGateway < Formula
  desc "Multi-provider LLM proxy for the Evo self-evolution agent system"
  homepage "https://github.com/ai-evo-agents/evo-gateway"
  version "0.7.5"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ai-evo-agents/evo-gateway/releases/download/v#{version}/evo-gateway-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "39e3bbb1e4a03f6ea89decf90f0c0e3c8a2654d3e039879b24a2378a3dfd125b"
    else
      url "https://github.com/ai-evo-agents/evo-gateway/releases/download/v#{version}/evo-gateway-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "ad02fe5605ea9e26e5f7639d68f64e85fb14e517051c07bc0825809559c299fa"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ai-evo-agents/evo-gateway/releases/download/v#{version}/evo-gateway-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "81b28e0052f3fa50057ccb3787e08d1dc85d3130a0f2cbed1ccdfd81500e7e62"
    else
      url "https://github.com/ai-evo-agents/evo-gateway/releases/download/v#{version}/evo-gateway-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "15ea010421df100eac16377cb71cf3cad000ee2328a3bf2417942a9f396ab91e"
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
