# Copyright (c) 2017-2018, Jan Cajthaml <jan.cajthaml@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Build stage
FROM golang:1.24-alpine AS builder

# Set working directory
WORKDIR /app

# Copy repo contents
COPY . .

# Change to the Go module directory
WORKDIR /app

# Build steps
RUN go mod verify
RUN go mod tidy
RUN go mod vendor
RUN go build -o /app/datadog_mock ./src

# Final stage
FROM scratch

ARG VERSION
ARG SOURCE

LABEL version=$VERSION
LABEL description="DataDog mock server"
LABEL source=$SOURCE

COPY --from=builder /app/datadog_mock /datadog_mock

EXPOSE 8125/UDP

ENTRYPOINT ["/app/datadog_mock"]
