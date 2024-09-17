# Compiler settings
SOLC := solc
SOLC_FLAGS := --optimize --optimize-runs 200

# Directories
SRC_DIR := src
TEST_DIR := test
BUILD_DIR := build
SCRIPT_DIR := script

# Files
SOURCES := $(wildcard $(SRC_DIR)/*.sol)
TESTS := $(wildcard $(TEST_DIR)/*.sol)

# Default target
all: compile test

# Compile all contracts
compile:
	@echo "Compiling contracts..."
	@forge compile

# Run tests
test: compile
	@echo "Running tests..."
	@forge test

start-anvil:
	@anvil --code-size-limit 50000

# Deploy to development network
deploy-dev: compile
	@echo "Deploying to development network..."
	@forge script scripts/DeployDevelopment.s.sol --broadcast --fork-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80  --code-size-limit 50000


# Clean build artifacts
clean:
	@echo "Cleaning build directory..."
	@rm -rf $(BUILD_DIR)

# Format Solidity files
format:
	@echo "Formatting Solidity files..."
	@forge fmt $(SRC_DIR) $(TEST_DIR) $(SCRIPT_DIR)

# Generate documentation
docs:
	@echo "Generating documentation..."
	@forge doc

# Help command
help:
	@echo "Available commands:"
	@echo "  make all          - Compile contracts and run tests"
	@echo "  make compile      - Compile all contracts"
	@echo "  make test         - Run all tests"
	@echo "  make deploy-dev   - Deploy to development network"
	@echo "  make clean        - Remove build artifacts"
	@echo "  make format       - Format Solidity files"
	@echo "  make docs         - Generate documentation"

.PHONY: all compile test deploy-dev clean format docs help
