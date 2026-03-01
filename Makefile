SRC_MDS=$(shell find src/ -type f -name '*.md')
SRC_ASSETS=$(shell find assets/ -type f)

OUT_HTML=$(patsubst src/%.md, out/%.html, $(SRC_MDS))
OUT_ASSETS=$(addprefix out/, $(SRC_ASSETS))
OUT_FEED="out/blog/feed.xml"

LOCAL_DOCKER_TAG="packrat386.com:local-dev"
LOCAL_DOCKER_PORTS="8080:8080"
LOCAL_DOCKER_FILE="Dockerfile"

all: $(OUT_HTML) $(OUT_ASSETS) $(OUT_FEED)

serve: local-image
	docker run -p $(LOCAL_DOCKER_PORTS) $(LOCAL_DOCKER_TAG)

local-image: $(OUT_HTML) $(OUT_ASSETS)
	docker build . -f $(LOCAL_DOCKER_FILE) -t $(LOCAL_DOCKER_TAG)

out/%.html: src/%.md
	mkdir -p $(@D)
	pandoc -s -i $< -r markdown -w html --template=templates/article -o $@

$(OUT_FEED): $(OUT_HTML)
	./mkatom.sh >$@

out/assets/%: assets/%
	mkdir -p $(@D)
	cp $< $@

.PHONY: clean
clean:
	rm -rf out/ || true
	docker rmi -f $(LOCAL_DOCKER_TAG)

# This is to test the release image, but it is not what is actually
# run by the github-actions release process.
.PHONY: release-image
release-image:
	docker build . -f Dockerfile.release
