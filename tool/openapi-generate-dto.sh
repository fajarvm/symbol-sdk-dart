#!/usr/bin/env bash

# Download NEM2 OpenAPI definition
# OpenAPI v3: https://raw.githubusercontent.com/nemtech/nem2-openapi/master/spec/openapi3.yaml
# https://github.com/OpenAPITools/openapi-generator/issues/2830
curl -O https://raw.githubusercontent.com/nemtech/nem2-openapi/master/spec/openapi3.yaml

# Install openapi-generator
brew list openapi-generator || brew install openapi-generator

# Generate DTO files
#
# Param: -c path/to/config.yml
# Uses the configuration file to configure package names, prefixes, model source, etc.
# The configuration file can be JSON or YML formatted.
#
# Param: --generate-alias-as-moodel
# Generates alias as model
#
# Param: --enable-post-process-file
# Enables post processing. Make sure the environment variable DART_POST_PROCESS_FILE is defined.
# For example: export DART_POST_PROCESS_FILE="/usr/local/bin/dartfmt -w"
#
# Developer note:
# There's currently an issue where the generated code require an outdated Dart library DSON.
openapi-generator generate -i openapi3.yaml -g dart -o ./out/codegen/ --generate-alias-as-model

# Copy DTO files
NEM2_API_DIR="../lib/src/api/"
NEM2_API_MODEL_DIR=$NEM2_API_DIR"model/"
mkdir -p $NEM2_API_MODEL_DIR
mv ./out/codegen/lib/model $NEM2_API_DIR

# Create a new api library file
FILE="./lib/src/api/infrastructure.dart"
touch $FILE
cat <<EOM >$FILE
library nem2_sdk_dart.sdk.api;

EOM

# Add all model files as part of the library
for filename in "$NEM2_API_MODEL_DIR"*.dart; do
    [ -e "$filename" ] || continue
        # Include file as part of the package
        basename "$filename";
        f="$(basename -- "$filename")";
        printf "part 'model/%s';\n" "$f" >> $FILE;
done

# Clean-up
rm -R ./out/codegen/