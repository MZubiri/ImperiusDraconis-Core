#!/bin/sh
set -eu

: "${API_URL:?Falta configurar la variable de entorno API_URL}"

config_dir=/usr/share/nginx/html/assets/config
template="$config_dir/runtime-config.template.json"
output="$config_dir/runtime-config.json"
temporary_output="$output.tmp"

mkdir -p "$config_dir"

if [ ! -f "$template" ]; then
  printf 'No existe el template runtime: %s\n' "$template" >&2
  exit 1
fi

envsubst '${API_URL}' < "$template" > "$temporary_output"
mv "$temporary_output" "$output"

printf 'Configuracion runtime generada en %s\n' "$output"
cat "$output"
