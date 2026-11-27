class AmgRfidGateway < Formula
  desc "AMG RFID Edge Gateway — syncs RFID readings from antennas to VPS"
  homepage "https://github.com/AMG-Repo/amg-rfid-gateway"
  version "0.8.8"
  license "MIT"

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AMG-Repo/amg-rfid-gateway/releases/download/v0.8.8/amg-rfid-gateway-v0.8.8-linux-arm64.tar.gz"
      sha256 "33fe21eeed28462da30356625904c67977704c6cd78523c01b6fb495ab5a0696"
    else
      url "https://github.com/AMG-Repo/amg-rfid-gateway/releases/download/v0.8.8/amg-rfid-gateway-v0.8.8-linux-amd64.tar.gz"
      sha256 "7f40aeed2fd76522acf3d8ffd8c4d151c3c909ee1d110e7096c65c2377650eec"
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
