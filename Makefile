```makefile
.DEFAULT_GOAL := all

SRC_DIR := src
OUT_DIR := out
SOURCES := $(wildcard $(SRC_DIR)/*.txt)
OUTPUTS := $(patsubst $(SRC_DIR)/%.txt,$(OUT_DIR)/%.txt,$(SOURCES))

.PHONY: all build check test clean ci count

all: build

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

$(OUT_DIR)/%.txt: $(SRC_DIR)/%.txt | $(OUT_DIR)
	@echo "BUILD $< -> $@"
	cp $< $@

build: $(OUTPUTS)

check: build
	@echo "Checking built files..."
	@test -n "$(OUTPUTS)"
	@for file in $(OUTPUTS); do test -f "$$file" || exit 1; done
	@echo "All output files exist."

test: check
	@echo "Tests passed."

clean:
	rm -rf $(OUT_DIR)

ci: clean check test

count: build ## report source files and built words
	@ls -1 $(SRC_DIR)/*.txt | wc -l
	@wc -w $(OUTPUTS) | tail -1
```

