ARG MIX_ENV="prod"

FROM hexpm/elixir:1.14.0-erlang-25.1-alpine-3.14.8 AS build

RUN apk add --no-cache build-base git python3 curl

WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force

ARG MIX_ENV
ENV MIX_ENV="${MIX_ENV}"

RUN mkdir apps
COPY apps/hakaton_muzika/mix.exs apps/hakaton_muzika/mix.exs
COPY apps/hakaton_muzika_web/mix.exs apps/hakaton_muzika_web/mix.exs
COPY apps/scanner/mix.exs apps/scanner/mix.exs

COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV

RUN mkdir config
COPY config/config.exs config/$MIX_ENV.exs config/runtime.exs config/

COPY apps apps 
RUN cd apps/hakaton_muzika_web && mix assets.deploy

RUN mix deps.compile

RUN mix compile

RUN MIX_ENV="prod" mix release

FROM alpine:3.14.8 AS app

ARG MIX_ENV

RUN apk add --no-cache libstdc++ openssl ncurses-libs

ENV USER="elixir"

WORKDIR "/home/${USER}/app"

RUN \
  addgroup \
   -g 1000 \
   -S "${USER}" \
  && adduser \
   -s /bin/sh \
   -u 1000 \
   -G "${USER}" \
   -h "/home/${USER}" \
   -D "${USER}" \
  && su "${USER}"


RUN chown ${USER} /home/${USER}/app

USER  "${USER}"

RUN touch app.db

RUN chmod 666 app.db

COPY --from=build --chown="${USER}":"${USER}" /app/_build/"${MIX_ENV}"/rel/hakaton_muzika_umbrella ./

CMD /bin/sh -c "bin/hakaton_muzika_umbrella eval \"HakatonMuzikaWeb.Release.migrate\" && bin/hakaton_muzika_umbrella start"
