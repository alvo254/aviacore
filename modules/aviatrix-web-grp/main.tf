terraform {
  required_providers {
    aviatrix = {
      source  = "aviatrixsystems/aviatrix"
      version = "3.1.4"
    }
  }
}



# Frontend Web Group - SNI Filter for frontend traffic
resource "aviatrix_web_group" "frontend_web_group" {
  name = "Frontend_Web_Group"

  selector {
    match_expressions {
      snifilter = "frontend.yourdomain.com"  # SNI for frontend traffic
    }
  }
}

# Backend Web Group - SNI Filter for backend traffic
resource "aviatrix_web_group" "backend_web_group" {
  name = "Backend_Web_Group"

  selector {
    match_expressions {
      snifilter = "backend.yourdomain.com"  # SNI for backend traffic
    }
  }
}

# Secret App Web Group - SNI Filter for secret app traffic
resource "aviatrix_web_group" "secret_app_web_group" {
  name = "Secret_App_Web_Group"

  selector {
    match_expressions {
      snifilter = "secretapp.yourdomain.com"  # SNI for secret app traffic
    }
  }
}
