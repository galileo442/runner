FROM ghcr.io/galileo442/runner/control@sha256:849f9cad565c735a6a33cac392801c3a8416a9c87b6b8ac73607e018fc4c2fe3 AS native
FROM docker:28-cli@sha256:625d9431a9f54c5a2bc90f24f0e1c3d55b1349fd857dd85035f98c2c9acbdd4d AS docker
FROM node:24-alpine@sha256:116b800c3754b440ee0aa3ed2f20f5bf3d99a554bfd9adeea09ea8017f6e85f5 AS base
LABEL org.opencontainers.image.source="https://github.com/galileo442/runner"
COPY --from=native /usr/local/share/runner-agent/rust/manifest.json /native/manifest.json
COPY --from=native /usr/local/share/runner-agent/rust/runner-agent-linux-amd64 /native/runner-agent-linux-amd64
COPY --from=native /usr/local/share/runner-agent/rust/runner-agent-linux-arm64 /native/runner-agent-linux-arm64
COPY control/migration/agent.mjs /migration/agent.mjs
ENTRYPOINT ["node", "/migration/agent.mjs"]

FROM base AS legacy-fixture
COPY --from=docker /usr/local/bin/docker /usr/local/bin/docker
COPY --from=docker /usr/local/libexec/docker/cli-plugins /usr/local/libexec/docker/cli-plugins
COPY agent/*.mjs /agent/
WORKDIR /agent
ENTRYPOINT ["node", "/agent/agent.mjs"]

FROM base AS release
