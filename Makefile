OUT_DIR=./out

all: build

build:
	mkdir -p $(OUT_DIR)
	crystal build --release bin/vicr -o $(OUT_DIR)/vicr

run:
	$(OUT_DIR)/vicr

clean:
	rm -rf $(OUT_DIR) .crystal .deps libs
