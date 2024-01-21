1. --rm
2. wheel  0.42.0
3. 15612
4. 2019-09-26
5. "Brooklyn" "Manhattan" "Queens"
6. JFK Airport
7.
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # google_bigquery_dataset.demo_dataset will be created    
  + resource "google_bigquery_dataset" "demo_dataset" {     
      + creation_time              = (known after apply)    
      + dataset_id                 = "demo_dataset"
      + default_collation          = (known after apply)    
      + delete_contents_on_destroy = false
      + effective_labels           = (known after apply)    
      + etag                       = (known after apply)    
      + id                         = (known after apply)    
      + is_case_insensitive        = (known after apply)    
      + last_modified_time         = (known after apply)    
      + location                   = "EU"
      + max_time_travel_hours      = (known after apply)    
      + project                    = "terraform-demo-411813"
      + self_link                  = (known after apply)    
      + storage_billing_model      = (known after apply)    
      + terraform_labels           = (known after apply)    
    }

  # google_storage_bucket.demo-bucket will be created       
  + resource "google_storage_bucket" "demo-bucket" {        
      + effective_labels            = (known after apply)   
      + force_destroy               = true
      + id                          = (known after apply)
      + location                    = "EU"
      + name                        = "terraform-demo-411813-terra-bucket"
      + project                     = (known after apply)
      + public_access_prevention    = (known after apply)
      + rpo                         = (known after apply)
      + self_link                   = (known after apply)
      + storage_class               = "STANDARD"
      + terraform_labels            = (known after apply)
      + uniform_bucket_level_access = (known after apply)
      + url                         = (known after apply)

      + lifecycle_rule {
          + action {
              + type = "AbortIncompleteMultipartUpload"
            }
          + condition {
              + age                   = 1
              + matches_prefix        = []
              + matches_storage_class = []
              + matches_suffix        = []
              + with_state            = (known after apply)
            }
        }
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: