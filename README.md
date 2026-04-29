# AMG RFID Edge Gateway for Raspberry Pi
Homebrew tap for AMG RFID tools.

## Installation

```bash
brew tap AMG-Repo/tap
brew install amg-rfid-gateway
```

Or in one line:

```bash
brew install AMG-Repo/tap/amg-rfid-gateway
```

## Usage

```bash
# Edit config
nano $(brew --prefix)/etc/amg-rfid-gateway/config.yaml

# Start as service
brew services start AMG-Repo/tap/amg-rfid-gateway

# Or run manually
gateway --config $(brew --prefix)/etc/amg-rfid-gateway/config.yaml
```
