class EvoKing < Formula
  desc "Central orchestrator for the Evo self-evolution agent system"
  homepage "https://github.com/ai-evo-agents/evo-king"
  version "0.5.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ai-evo-agents/evo-king/releases/download/v#{version}/evo-king-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "cb087b7227a76892825d70bf55dac832b45999a16878c23c942e055f27dfbf39"
    else
      url "https://github.com/ai-evo-agents/evo-king/releases/download/v#{version}/evo-king-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "5c6f0ec018c179717b311a3ebdcf5e19eb12ea213af915ff42c002b260ab62d5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ai-evo-agents/evo-king/releases/download/v#{version}/evo-king-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "148f760e10f0b4d0bdf87282ca7cf4337468a4187746b31a99772b0f7a82b2c5"
    else
      url "https://github.com/ai-evo-agents/evo-king/releases/download/v#{version}/evo-king-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5630901b467e6286d7563a0080468d6336a083997c0a7457ed9621acfec23137"
    end
  end

  def install
    bin.install "evo-king"

    # Install run.sh and update.sh if present in the archive
    prefix.install "run.sh" if File.exist?("run.sh")
    (var/"evo-agents/data").install "update.sh" if File.exist?("update.sh")

    # Install dashboard if present
    if File.directory?("dashboard")
      (share/"evo-king/dashboard").install Dir["dashboard/*"]
    end
  end

  def post_install
    # Create data and log directories
    (var/"evo-agents/data").mkpath
    (var/"evo-agents/data/backups").mkpath
    (var/"evo-agents/logs").mkpath
  end

  def caveats
    <<~EOS
      evo-king data is stored in:
        #{var}/evo-agents/data/

      Logs are written to:
        #{var}/evo-agents/logs/

      Start the server:
        evo-king

      Environment variables:
        KING_PORT           Port for Socket.IO/HTTP server (default: 3300)
        KING_DB_PATH        Path to libSQL database (default: king.db)
        KERNEL_AGENTS_DIR   Directory containing evo-kernel-agent-* repos
        EVO_LOG_DIR         Log output directory
        EVO_OTLP_ENDPOINT   OTLP endpoint for distributed tracing (optional)
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evo-king --version")
  end
end
