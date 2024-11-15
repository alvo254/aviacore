terraform {
  required_providers {
    aviatrix = {
      source  = "aviatrixsystems/aviatrix"
      version = "3.1.4"
    }
  }
}




# Frontend Smart Group - Public Subnets (Using Name Tag)
resource "aviatrix_smart_group" "frontend_smart_group" {
  name = "Frontend_Smart_Group"

  selector {
    match_expressions {
      type   = "vm"
      region = "us-east-1"  # This is similar to adding a condion using the aviatrix UI
      tags = {
        Name = "SAP flori-sim"  # Match based on EC2 instance name
      }
    }
    
    match_expressions {
      type   = "vm"
      region = "us-east-1"  
      tags = {
        Name = "customer-fascing-react"  
      }
    }

    match_expressions {
      type   = "vm"
      region = "us-east-1"  
      tags = {
        Name = "redundant_flori-sim" 
      }
    }
  }
}

# Backend Smart Group - Private Subnets (Using Name Tag)
resource "aviatrix_smart_group" "backend_smart_group" {
  name = "Backend_Smart_Group"

  selector {
    match_expressions {
      type   = "vm"
      region = "us-east-1"  
      tags = {
        Name = "4HANA-sim"  
      }
    }

    match_expressions {
      type   = "vm"
      region = "us-east-1"  
      tags = {
        Name = "redundant-4HANA-sim"  
      }
    }
  }
}

# Secret App Smart Group - Private Subnet (Using Name Tag)
resource "aviatrix_smart_group" "secret_app_smart_group" {
  name = "Secret_App_Smart_Group"

  selector {
    match_expressions {
      type   = "vm"
      region = "us-east-1"  
      tags = {
        Name = "secret_app"  
      }
    }
  }
}

# Aviatrix Public Subnet Filtering Smart Group (Using Name Tag)
resource "aviatrix_smart_group" "aviatrix_psf_smart_group" {
  name = "Aviatrix_PSF_Smart_Group"

  selector {
    match_expressions {
      type   = "vm"
      region = "us-east-1"  
      tags = {
        Name = "SAP flori-sim"  
      }
    }

    match_expressions {
      type   = "vm"
      region = "us-east-1"  
      tags = {
        Name = "customer-fascing-react" 
      }
    }

    match_expressions {
      type   = "vm"
      region = "us-east-1"  
      tags = {
        Name = "redundant_flori-sim"  
      }
    }
  }
}
