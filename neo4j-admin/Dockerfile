ARG GO_VERSION=1.22
FROM --platform=${BUILDPLATFORM:-linux/amd64} golang:${GO_VERSION}-bullseye AS build

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH

RUN apt-get update && apt-get install -y curl
WORKDIR /staging
COPY backup/aws aws/
COPY backup/azure azure/
COPY backup/gcp gcp/
COPY backup/common common/
COPY backup/main main/
COPY backup/neo4j-admin neo4j-admin/
COPY backup/go.mod go.mod
RUN go mod tidy && go mod download && go mod verify
RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o backup_linux main/*

FROM neo4j:5.25.1-enterprise-bullseye AS final
ARG DISTRIBUTION
RUN \
    if [ "${DISTRIBUTION}" = "debian" ]; then  \
      apt-get update && apt-get install -y bash netcat-openbsd curl wget gnupg apt-transport-https apt-utils lsb-release unzip less && rm -rf /var/lib/apt/lists/* ;  \
    else  \
      # for redhat
      microdnf update -y && microdnf install -y bash nc wget gnupg yum-utils unzip less ;  \
    fi
COPY --from=build /staging/backup_linux bin/backup
ENV NEO4J_server_config_strict__validation_enabled=false
ENV NEO4J_ACCEPT_LICENSE_AGREEMENT=yes
RUN chown neo4j:neo4j bin/backup
CMD ["bin/backup"]
