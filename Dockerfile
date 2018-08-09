##############
# Build Cuwo #
##############
FROM python:3.6-alpine as build

WORKDIR /tmp 

# ---------------------------------------
# Clone Cuwo, install requirements, setup
# ---------------------------------------
RUN apk add --update --no-cache git gcc musl-dev g++ make \
 && git clone https://github.com/matpow2/cuwo.git . \
 && pip install -r requirements.txt \
 && python setup.py build_ext --inplace

#######
# Run #
#######
FROM python:3.6-alpine

LABEL maintainer "docker@marcermarc.de"

# -----------------------------------------
# Copy only required files from build-image
# -----------------------------------------
COPY --from=build /tmp/cuwo/*.py /tmp/cuwo/*.so /opt/cuwo/cuwo/
COPY --from=build /tmp/scripts/ /opt/cuwo/scripts/
COPY --from=build /tmp/requirements.txt /opt/cuwo/

WORKDIR /opt/cuwo

# ---------------------------------------------------------------------
# Install gcc to run cuwo (requirement cython needs this)
# Cython needs for installation some more packages (build-dependencies)
# Install requirements for running cuwo
# Adds user and set the rights
# ---------------------------------------------------------------------
RUN apk add --update --no-cache gcc \
 && apk add --update --no-cache --virtual=.build-dependencies musl-dev g++ make \
 && pip install -r requirements.txt \
 && apk del .build-dependencies \
 && adduser -D cuwo -h /opt \
 && chown -R cuwo /opt \
 && chmod -R 777 /opt

# -----------
# Expose port
# -----------
EXPOSE 12345:12345/tcp

# -----------------------------------------------------------------------------------
# Define volumes
# - config for configuration
# - save for bans
# - data for the world and the original game files: data1.db, data4.db and Server.exe
# -----------------------------------------------------------------------------------
VOLUME ["/opt/cuwo/config", "/opt/cuwo/save", "/opt/cuwo/data"]

# ----------------
# Set startup user
# ----------------
USER cuwo

# --------------------------------------
# Starts directly the python/cuwo-server
# --------------------------------------
ENTRYPOINT ["python", "-m", "cuwo.server", "."]
