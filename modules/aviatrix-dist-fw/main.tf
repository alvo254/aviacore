terraform {
  required_providers {
    aviatrix = {
      source  = "aviatrixsystems/aviatrix"
      version = "3.1.4"
    }
  }
}

//I am not sure if this will `commit` the fw rule.........?

# Create an Aviatrix Distributed Firewalling Policy List
resource "aviatrix_distributed_firewalling_policy_list" "test" {
  policies {
    name             = "df-policy-1"
    action           = "DENY"
    priority         = 1
    protocol         = "ICMP"
    logging          = true
    watch            = false
    src_smart_groups = [
      "f15c9890-c8c4-4c1a-a2b5-ef0ab34d2e30"
    ]
    dst_smart_groups = [
      "82e50c85-82bf-4b3b-b9da-aaed34a3aa53"
    ]
  }

  policies {
    name             = "df-policy"
    action           = "PERMIT"
    priority         = 0
    protocol         = "TCP"
    src_smart_groups = [
      "7e7d1573-7a7a-4a53-bcb5-1ad5041961e0"
    ]
    dst_smart_groups = [
      "f05b0ad7-d2d7-4d16-b2f6-48492319414c"
    ]

    port_ranges {
      hi = 50000
      lo = 49000
    }
  }
}

