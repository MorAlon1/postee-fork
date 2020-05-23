GOPATH=$(CURDIR)
GO_FMT=gofmt
GO_GET=go get
GO_BUILD=go build
GO_INSTALL=go install
GO_CLEAN=go clean
EXENAME=webhooksrv
BUILDPATH=$(CURDIR)

.PHONY: all clean get build fmt vet test

default : all

makedir :
	@if [ ! -d $(BUILDPATH)/bin ] ; then mkdir -p $(BUILDPATH)/bin ; fi
	@if [ ! -d $(BUILDPATH)/pkg ] ; then mkdir -p $(BUILDPATH)/pkg ; fi

build :
	@echo "building...."
	$(GO_INSTALL)  $(EXENAME)
	@echo "Done!"

get :
	@echo "download 3rd party packages...."
	@$(GO_GET) github.com/spf13/cobra
	@$(GO_GET) github.com/gorilla/mux
	@$(GO_GET) github.com/ghodss/yaml
	@$(GO_GET) github.com/andygrunwald/go-jira
	@$(GO_GET) go.etcd.io/bbolt

all : makedir get build

clean :
	@echo "cleaning...."
	@rm -rf $(BUILDPATH)/bin/$(EXENAME)
	@rm -rf $(BUILDPATH)/pkg

docker :
	@echo "Building image...."
	docker build -t aquasec/webhook-server:latest -f Dockerfile.webhook-server .

fmt :
	@echo "fmt...."
	$(GO_FMT) -w ./src

test :
	go test ./src/scanservice -v -coverprofile=scanservice.out
	go test ./src/dbservice -v -coverprofile=dbservice.out

	go tool cover -html=scanservice.out
	go tool cover -html=dbservice.out