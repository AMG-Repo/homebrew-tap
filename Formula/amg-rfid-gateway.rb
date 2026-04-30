class AmgRfidGateway < Formula
  desc "AMG RFID Edge Gateway — syncs RFID readings from antennas to VPS"
  homepage "https://github.com/AMG-Repo/amg-rfid-gateway"
  version "0.3.0"
  license "MIT"

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/AMG-Repo/amg-rfid-gateway/releases/download/v#{version}/amg-rfid-gateway-v#{version}-linux-arm64.tar.gz"
      sha256 "cefb17ec5ad544c0bd58ac011196b609f9927b37cf3e424a0101e015cce91988"
    else
      url "https://github.com/AMG-Repo/amg-rfid-gateway/releases/download/v#{version}/amg-rfid-gateway-v#{version}-linux-amd64.tar.gz"
      sha256 "e697bd04db8acbe84bb2255f4cc21abb83b2496e0ec7ef449afa59f4c9e601fe"
    end
  end

  def install
    bin.install "gateway"
    bin.install "gateway-tui"
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
