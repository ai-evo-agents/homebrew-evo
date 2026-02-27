class EvoKing < Formula
  desc "Central orchestrator for the Evo self-evolution agent system"
  homepage "https://github.com/ai-evo-agents/evo-king"
  version "0.3.3"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ai-evo-agents/evo-king/releases/download/v#{version}/evo-king-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "93ddaee00b85ee77f748d2ddd84cbb2944728d633dd0802fe7b1dd85507e2295"
    else
      url "https://github.com/ai-evo-agents/evo-king/releases/download/v#{version}/evo-king-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "77c07afa8487407b1286377244203b56a3d0be828080811c236488fd041ef66b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ai-evo-agents/evo-king/releases/download/v#{version}/evo-king-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b72186fa630e83d1ea619071f371d5048735ab198ed4efa54d6dc3c35576254d"
    else
      url "https://github.com/ai-evo-agents/evo-king/releases/download/v#{version}/evo-king-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b96ba451f79881a329ff31b0940c5baefe733676ac7ee40cff66e658db8cfee9"
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
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evo-king --version")
  end
end
