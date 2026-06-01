class AmgRfidGateway < Formula
  desc "AMG RFID Edge Gateway — syncs RFID readings from antennas to VPS"
  homepage "https://github.com/AMG-Repo/amg-rfid-gateway"
  version "0.6.1"
  license "MIT"

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AMG-Repo/amg-rfid-gateway/releases/download/v0.6.1/amg-rfid-gateway-v0.6.1-linux-arm64.tar.gz"
      sha256 "4b5e4156f3131ec6fd634a01180b1defb986cb4e3bfe21ee759896bbe1fb1967"
    else
      url "https://github.com/AMG-Repo/amg-rfid-gateway/releases/download/v0.6.1/amg-rfid-gateway-v0.6.1-linux-amd64.tar.gz"
      sha256 "0733f843b35b02220eb4b64d801b0ff511551ba6a3b34167150489920f2d1950"
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
