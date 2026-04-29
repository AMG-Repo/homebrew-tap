class AmgRfidGateway < Formula
  desc "AMG RFID Edge Gateway — syncs RFID readings from antennas to VPS"
  homepage "https://github.com/AMG-Repo/amg-rfid-gateway"
  version "0.1.0"
  license "MIT"

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AMG-Repo/amg-rfid-gateway/releases/download/v#{version}/amg-rfid-gateway-v#{version}-linux-arm64.tar.gz"
      sha256 "2f8d96494d68e6fbe849fd39ef7005f5c3beca902b32fd48b1d0014306a84e50"
    else
      url "https://github.com/AMG-Repo/amg-rfid-gateway/releases/download/v#{version}/amg-rfid-gateway-v#{version}-linux-amd64.tar.gz"
      sha256 "07a4cd992f4aa27abd5b8234e8643aa9cc4319d83f2c4511dbea4d3c97f6d3a5"
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
