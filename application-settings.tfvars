application_settings = {
  "alpha-app" = {
    blue_stage        = "one"
    green_stage       = "two"
    green_weight      = 0
    stage_one_image   = "mcr.microsoft.com/dotnet/samples:aspnetapp"
    stage_two_image   = "mcr.microsoft.com/dotnet/samples:aspnetapp"
    stage_three_image = ""
  }
  "beta-app" = {
    blue_stage        = "one"
    green_stage       = "two"
    green_weight      = 100
    stage_one_image   = "mcr.microsoft.com/dotnet/samples:aspnetapp"
    stage_two_image   = "mcr.microsoft.com/dotnet/samples:aspnetapp"
    stage_three_image = ""
  }
  "charlie-app" = {
    blue_stage        = "one"
    green_stage       = "two"
    green_weight      = 50
    stage_one_image   = "mcr.microsoft.com/dotnet/samples:aspnetapp"
    stage_two_image   = "mcr.microsoft.com/dotnet/samples:aspnetapp"
    stage_three_image = ""
  }
  # "delta-app" = {
  #   blue_stage        = "three"
  #   green_stage       = "one"
  #   green_weight      = 25
  #   stage_one_image   = "mcr.microsoft.com/dotnet/samples:aspnetapp"
  #   stage_two_image   = ""
  #   stage_three_image = "mcr.microsoft.com/dotnet/samples:aspnetapp"
  # }
  # "echo-app" = {
  #   blue_stage        = "one"
  #   green_stage       = "three"
  #   green_weight      = 33
  #   stage_one_image   = "mcr.microsoft.com/dotnet/samples:aspnetapp"
  #   stage_two_image   = ""
  #   stage_three_image = "mcr.microsoft.com/dotnet/samples:aspnetapp"
  # }
  # "foxtrot-app" = {
  #   blue_stage        = "two"
  #   green_stage       = "three"
  #   green_weight      = 17
  #   stage_one_image   = ""
  #   stage_two_image   = "mcr.microsoft.com/dotnet/samples:aspnetapp"
  #   stage_three_image = "mcr.microsoft.com/dotnet/samples:aspnetapp"
  # }
}
