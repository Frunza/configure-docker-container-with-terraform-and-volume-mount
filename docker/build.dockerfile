FROM hashicorp/terraform:1.5.0

# Copy app repo
COPY ./../terraform /infrastructure
