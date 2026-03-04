FROM python:3.12
ENV LANG C.UTF-8

# System deps
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libpq-dev \
    libxml2-dev \
    libxslt1-dev \
    libldap2-dev \
    libsasl2-dev \
    libjpeg-dev \
    libpng-dev \
    liblcms2-dev \
    libblas-dev \
    libopenblas-dev \
    libffi-dev \
    libssl-dev \
    libevent-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Create odoo user
RUN useradd -ms /bin/bash odoo

WORKDIR /opt/odoo
COPY . .

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip setuptools wheel
RUN pip install -r requirements.txt

# Set permissions

RUN chown -Rf odoo:odoo /opt/odoo
USER odoo

# Set default environment variables (can be overridden at runtime)
ENV CONFIG_FILE=/etc/odoo.conf

EXPOSE 8069 8071 8072

# Use shell form to allow variable expansion
CMD python3 odoo-bin --config "$CONFIG_FILE"
