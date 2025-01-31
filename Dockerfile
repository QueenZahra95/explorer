#
# Copyright (C) 2021-2022 diva.exchange
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
# Author/Maintainer: Konrad Bächler <konrad@diva.exchange>
#

FROM node:14-slim AS build

LABEL author="Konrad Baechler <konrad@diva.exchange>" \
  maintainer="Konrad Baechler <konrad@diva.exchange>" \
  name="explorer" \
  description="Distributed digital value exchange upholding security, reliability and privacy" \
  url="https://diva.exchange"

COPY bin /explorer/bin
COPY src /explorer/src
COPY static /explorer/static
COPY view /explorer/view
COPY package.json /explorer/package.json
COPY tsconfig.json /explorer/tsconfig.json

RUN cd explorer \
  && mkdir build \
  && npm i -g pkg \
  && npm i --production \
  && bin/build.sh

FROM gcr.io/distroless/cc
COPY --from=build /explorer/build/explorer-linux-amd64 /explorer

EXPOSE 3920

CMD [ "/explorer" ]
