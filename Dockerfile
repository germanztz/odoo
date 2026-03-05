FROM python:3.12
ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y \
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
    node-less \
    npm \
    ca-certificates \
    curl \
    dirmngr \
    fonts-noto-cjk \
    gnupg \
    libssl-dev \
    python3-pyldap \
    python3-magic \
    python3-num2words \
    python3-odf \
    python3-pdfminer \
    python3-phonenumbers \
    python3-qrcode \
    python3-renderpm \
    python3-setuptools \
    python3-slugify \
    python3-vobject \
    python3-watchdog \
    python3-xlrd \
    python3-xlwt \
    xz-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# RUN curl -o wkhtmltox.deb -sSL https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.jammy_amd64.deb \
#     && apt-get install -y --no-install-recommends ./wkhtmltox.deb \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/* wkhtmltox.deb

# Install rtlcss (on Debian buster)
RUN npm install -g rtlcss

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
