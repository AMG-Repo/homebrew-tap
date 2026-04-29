class AmgRfidGateway < Formula
  desc "AMG RFID Edge Gateway — syncs RFID readings from antennas to VPS"
  homepage "https://github.com/AMG-Repo/amg-rfid-gateway"
  version "0.1.0"
  license "MIT"

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AMG-Repo/amg-rfid-gateway/releases/download/v#{version}/amg-rfid-gateway-v#{version}-linux-arm64.tar.gz"
      sha256 "PLACEHOLDER_ARM64_SHA256"
    else
      url "https://github.com/AMG-Repo/amg-rfid-gateway/releases/download/v#{version}/amg-rfid-gateway-v#{version}-linux-amd64.tar.gz"
      sha256 "PLACEHOLDER_AMD64_SHA256"
    end
  end

  def install
    bin.install "gateway"
    bin.install "tui"
    pkgetc.install "config.example.yaml" => "config.yaml"
    (var/"lib/amg-rfid-gateway").mkpath
  end

  def post_install
    ohai "AMG RFID Gateway v#{version} installed!"
    puts <<~EOS

      Config:  #{etc}/amg-rfid-gateway/config.yaml
      Data:    #{var}/lib/amg-rfid-gateway

      Next steps:
        1. Edit config:    nano #{etc}/amg-rfid-gateway/config.yaml
        2. Start service:  brew services start AMG-Repo/tap/amg-rfid-gateway
        3. Or run manual:  gateway --config #{etc}/amg-rfid-gateway/config.yaml

    EOS
  end

  service do
    run [opt_bin/"gateway", "--config", etc/"amg-rfid-gateway/config.yaml"]
    working_dir var/"lib/amg-rfid-gateway"
    keep_alive true
    log_path var/"log/amg-rfid-gateway.log"
    error_log_path var/"log/amg-rfid-gateway.log"
  end

  test do
    assert_match "amg-rfid-gateway", shell_output("#{bin}/gateway --version 2>&1", 1)
  end
end
