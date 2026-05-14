class AmgRfidGateway < Formula
  desc "AMG RFID Edge Gateway — syncs RFID readings from antennas to VPS"
  homepage "https://github.com/AMG-Repo/amg-rfid-gateway"
  version "0.4.0"
  license "MIT"

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AMG-Repo/amg-rfid-gateway/releases/download/v0.4.0/amg-rfid-gateway-v0.4.0-linux-arm64.tar.gz"
      sha256 "a323f7b6ebf7ec3d27a89208c2b777139efd50317a6b67f8903a0670430f8520"
    else
      url "https://github.com/AMG-Repo/amg-rfid-gateway/releases/download/v0.4.0/amg-rfid-gateway-v0.4.0-linux-amd64.tar.gz"
      sha256 "991d47202c27d8e519e134ece1a061447b980b5ec732f662cb814fae201eb5aa"
    end
  end

  def install
    bin.install "gateway"
    bin.install "tui"
    pkgetc.install "config.example.yaml" => "config.yaml"
    (var/"lib/amg-rfid-gateway").mkpath
  end

  def post_install
    ohai "AMG RFID Gateway v\#{version} installed!"
    puts <<~INFO

      Config:  \#{etc}/amg-rfid-gateway/config.yaml
      Data:    \#{var}/lib/amg-rfid-gateway

      Quick start:
        gateway                  # auto-detects config

      Or as service:
        brew services start AMG-Repo/tap/amg-rfid-gateway

    INFO
  end

  service do
    run [opt_bin/"gateway"]
    working_dir var/"lib/amg-rfid-gateway"
    keep_alive true
    log_path var/"log/amg-rfid-gateway.log"
    error_log_path var/"log/amg-rfid-gateway.log"
  end

  test do
    assert_match "amg-rfid-gateway", shell_output("\#{bin}/gateway --version 2>&1", 1)
  end
end
