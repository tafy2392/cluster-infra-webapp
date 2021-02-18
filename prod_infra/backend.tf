terraform {
  backend "gcs" {
    bucket = "munya-clusterapps-state-storage"
  }
}
