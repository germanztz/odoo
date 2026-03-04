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
ENV DB_HOST=db
ENV DB_PORT=5432
ENV DB_USER=odoo
ENV DB_PASSWORD=odoo
ENV HTTP_PORT=8069
ENV DATA_DIR=/var/lib/odoo
ENV DEV_FEATURE=all
ENV ADDONS_PATH=/mnt/extra-addons
ENV ADMIN_PASSWD=admin
# csv_internal_sep = ,
# db_maxconn = 64
# db_name = False
# db_template = template1
# dbfilter = .*
# debug_mode = False
# email_from = False
# limit_memory_hard = 2684354560
# limit_memory_soft = 2147483648
# limit_request = 8192
# limit_time_cpu = 60
# limit_time_real = 120
# list_db = True
# log_db = False
# log_handler = [':INFO']
# log_level = info
# logfile = None
# longpolling_port = 8072
# max_cron_threads = 2
# osv_memory_age_limit = 1.0
# osv_memory_count_limit = False
# smtp_password = False
# smtp_port = 25
# smtp_server = localhost
# smtp_ssl = False
# smtp_user = False
# workers = 0
# xmlrpc = True
# xmlrpc_interface = 
# xmlrpc_port = 8069
# xmlrpcs = True
# xmlrpcs_interface = 
# xmlrpcs_port = 8071

EXPOSE 8069 8071 8072

# Use shell form to allow variable expansion
CMD python3 odoo-bin \
    --db_host "$DB_HOST" \
    --db_port "$DB_PORT" \
    --db_user "$DB_USER" \
    --db_password "$DB_PASSWORD" \
    --http-port "$HTTP_PORT" \
    --data-dir "$DATA_DIR" \
    --dev "$DEV_FEATURE" \
    --addons-path "$ADDONS_PATH" \
    --admin_passwd "$ADMIN_PASSWD" 