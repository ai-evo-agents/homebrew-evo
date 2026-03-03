class EvoKing < Formula
  desc "Central orchestrator for the Evo self-evolution agent system"
  homepage "https://github.com/ai-evo-agents/evo-king"
  version "0.6.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ai-evo-agents/evo-king/releases/download/v#{version}/evo-king-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "6383e16ce8517e7825a78964e643979403e9279b1c27cf5e1c9cd9b1abf948db"
    else
      url "https://github.com/ai-evo-agents/evo-king/releases/download/v#{version}/evo-king-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "19fbd56c7b25f8cbb56f9dcd32b805b7e8a4d49de94a2616dc83572b4e05186f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ai-evo-agents/evo-king/releases/download/v#{version}/evo-king-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b224133eb7d0f7b9294b333f144fd380c2259e86b36b6adbc5e15f2ef806b904"
    else
      url "https://github.com/ai-evo-agents/evo-king/releases/download/v#{version}/evo-king-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9b294728c53da81b0c9bcf3ef9711eb21acb690b2f96ba366ddcbf3c275094e3"
    end
  end

  def install
    bin.install "evo-king"

    prefix.install "run.sh" if File.exist?("run.sh")
    (var/"evo-agents/data").install "update.sh" if File.exist?("update.sh")

    if File.directory?("dashboard")
      (share/"evo-king/dashboard").install Dir["dashboard/*"]
    end
  end

  def post_install
    (var/"evo-agents/data").mkpath
    (var/"evo-agents/data/backups").mkpath
    (var/"evo-agents/logs").mkpath
  end

  service do
    run [opt_bin/"evo-king"]
    keep_alive true
    log_path var/"evo-agents/logs/evo-king.log"
    error_log_path var/"evo-agents/logs/evo-king.error.log"
    environment_variables(
      KING_PORT: "3300",
      RUST_LOG: "info",
      EVO_LOG_DIR: var/"evo-agents/logs",
      KING_DB_PATH: var/"evo-agents/data/king.db",
      EVO_DASHBOARD_DIR: "#{HOMEBREW_PREFIX}/share/evo-king/dashboard",
    )
    working_dir var/"evo-agents/data"
  end

  def caveats
    <<~EOS
      evo-king data is stored in:
        #{var}/evo-agents/data/

      Logs are written to:
        #{var}/evo-agents/logs/

      Dashboard is served at:
        http://localhost:3300/

      To run as a background service:
        brew services start evo-king

      Or run manually:
        evo-king

      Environment variables:
        KING_PORT           Port for Socket.IO/HTTP server (default: 3300)
        KING_DB_PATH        Path to libSQL database (default: king.db)
        EVO_DASHBOARD_DIR   Path to dashboard static files
        KERNEL_AGENTS_DIR   Directory containing evo-kernel-agent-* repos
        EVO_LOG_DIR         Log output directory
        EVO_OTLP_ENDPOINT   OTLP endpoint for distributed tracing (optional)
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evo-king --version")
  end
end
