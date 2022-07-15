all: build/olricd build/olric-cloud-plugin.so

.PHONY: clean
clean:
	rm -rf build

build/olricd: go.mod go.sum
	mkdir -p $(dir $@)
	go build -o $@ github.com/buraksezer/olric/cmd/olricd

build/olric-cloud-plugin.so: go.mod go.sum
	mkdir -p $(dir $@)
	go build -buildmode=plugin -o $@ github.com/buraksezer/olric-cloud-plugin
