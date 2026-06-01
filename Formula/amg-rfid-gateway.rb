class AmgRfidGateway < Formula
  desc "AMG RFID Edge Gateway — syncs RFID readings from antennas to VPS"
  homepage "https://github.com/AMG-Repo/amg-rfid-gateway"
  version "0.6.2"
  license "MIT"

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AMG-Repo/amg-rfid-gateway/releases/download/v0.6.2/amg-rfid-gateway-v0.6.2-linux-arm64.tar.gz"
      sha256 "0bba1109535dea3b2ab90b0c83dcd1b1d1b61492ff39a8b9a31e0c7e5ec34477"
    else
      url "https://github.com/AMG-Repo/amg-rfid-gateway/releases/download/v0.6.2/amg-rfid-gateway-v0.6.2-linux-amd64.tar.gz"
      sha256 "4fea9b766b9568ce1ed74a3d5b2f3e79106357979e5ee66ae05d6d17be305f2e"
    end
  end

  def install
    bin.install "gateway"
    bin.install "gateway-tui"
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
