class EvoGateway < Formula
  desc "Multi-provider LLM proxy for the Evo self-evolution agent system"
  homepage "https://github.com/ai-evo-agents/evo-gateway"
  version "0.2.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ai-evo-agents/evo-gateway/releases/download/v#{version}/evo-gateway-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "a969a391a80e5a4597212c69319b27f474497794b67d47d50d4fd11342a34be4"
    else
      url "https://github.com/ai-evo-agents/evo-gateway/releases/download/v#{version}/evo-gateway-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "a74a495cd36d57d214fc84dbd0fe6ee4a3d88836f2ec97f5caf4c9b21d8ba301"
    end
  end

  on_linux do
    url "https://github.com/ai-evo-agents/evo-gateway/releases/download/v#{version}/evo-gateway-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "67653aaec131f8075a81ec87c327aacc8a663faa669257fc21eebf3e5303bc87"
  end

  def install
    bin.install "evo-gateway"
  end

  def caveats
    <<~EOS
      evo-gateway proxies LLM API requests to multiple providers.

      Start the server:
        evo-gateway

      Configure providers in gateway.json.

      Environment variables:
        OPENAI_API_KEY      OpenAI API key
        ANTHROPIC_API_KEY   Anthropic API key
        RUST_LOG            Log level (default: info)
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evo-gateway --version")
  end
end
