class AmgRfidGateway < Formula
  desc "AMG RFID Edge Gateway — syncs RFID readings from antennas to VPS"
  homepage "https://github.com/AMG-Repo/amg-rfid-gateway"
  version "0.2.1"
  license "MIT"

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AMG-Repo/amg-rfid-gateway/releases/download/v#{version}/amg-rfid-gateway-v#{version}-linux-arm64.tar.gz"
      sha256 "2f53297b2952fbe9c41bb0a10cc7cf1f108b833c8a48a71b892ca29f66cf0da8"
    else
      url "https://github.com/AMG-Repo/amg-rfid-gateway/releases/download/v#{version}/amg-rfid-gateway-v#{version}-linux-amd64.tar.gz"
      sha256 "7eda014f74473fab0852c0cfc37c9e590d675b395c285da5d3b87df9518d5b5f"
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

      Quick start:
        gateway                  # auto-detects config
        amg-rfid-gateway         # same thing

      Or as service:
        brew services start AMG-Repo/tap/amg-rfid-gateway

    EOS
  end

  service do
    run [opt_bin/"gateway"]
    working_dir var/"lib/amg-rfid-gateway"
    keep_alive true
    log_path var/"log/amg-rfid-gateway.log"
    error_log_path var/"log/amg-rfid-gateway.log"
  end

  test do
    assert_match "amg-rfid-gateway", shell_output("#{bin}/gateway --version 2>&1", 1)
  end
end
